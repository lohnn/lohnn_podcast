import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:podcast/data/episode_impl.model.dart';
import 'package:podcast/data/play_queue_item.model.dart';
import 'package:podcast/data/podcast_impl.model.dart';
import 'package:podcast/data/podcast_search_impl.dart';
import 'package:podcast/data/user_episode_status_impl.model.dart';
import 'package:podcast/repository/adapters/hive_registrar.g.dart';
import 'package:podcast/repository/search_headers_interceptor.dart';
import 'package:podcast_common/podcast_common.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/data/episode_with_status.dart';
import 'package:podcast_core/data/podcast.model.dart';
import 'package:podcast_core/data/podcast_search.model.dart';
import 'package:podcast_core/data/podcast_with_status.dart';
import 'package:podcast_core/data/user_episode_status.model.dart';
import 'package:podcast_core/repository.dart' as core;

class RepositoryImpl implements core.Repository {
  factory RepositoryImpl() {
    final podcastIndexDio = Dio(
      BaseOptions(baseUrl: 'https://api.podcastindex.org/api/1.0/'),
    );
    podcastIndexDio.interceptors.add(const SearchHeadersInterceptor());
    return RepositoryImpl._(podcastIndexDio: podcastIndexDio, dio: Dio())
      ..init();
  }

  RepositoryImpl._({required this.podcastIndexDio, required this.dio});

  final Dio dio;
  final Dio podcastIndexDio;

  Future<Box<PodcastImpl>> get podcastBox => Hive.openBox('podcastBox');

  Future<Box<PlayQueueItem>> get queueItemBox => Hive.openBox('queueItemBox');

  Future<Box<EpisodeImpl>> get episodeBox => Hive.openBox('episodeBox');

  Future<Box<DateTime>> get lastSeenBox => Hive.openBox('lastSeenBox');

  Future<Box<UserEpisodeStatusImpl>> get userEpisodeStatusBox =>
      Hive.openBox('userEpisodeStatusBox');

  void init() {
    Hive
      ..init(Directory.current.path)
      ..registerAdapters();

    episodeBox.then((box) {
      box.listenable().addListener(
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        _episodesUpdatedChangeNotifier.notifyListeners,
      );
    });

    podcastBox.then((box) {
      box.listenable().addListener(
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        _userPodcastSubscriptionsChangeNotifier.notifyListeners,
      );
    });
  }

  @override
  Future<List<PodcastSearch>> findPodcasts([String? searchTerm]) async {
    final path = switch (searchTerm) {
      null || '' => '/podcasts/trending?max=10',
      _ => '/search/byterm',
    };
    final response = await podcastIndexDio.get<Map<String, dynamic>>(
      path,
      queryParameters: switch (searchTerm) {
        null || '' => {'max': 10},
        final String query => {'fulltext': true, 'similar': true, 'q': query},
      },
    );

    final {'feeds': List<dynamic> feeds} = response.data!;
    final podcasts = feeds
        .map(
          (feed) =>
              PodcastSearchImplMapper.fromMap(feed as Map<String, dynamic>),
        )
        .toList(growable: false);

    return podcasts;
  }

  @override
  Future<void> deletePlayQueueItem(covariant PlayQueueItem queueItem) async {
    final box = await queueItemBox;
    await box.delete(queueItem.episodeId);
  }

  @override
  Future<List<PlayQueueItem>> getPlayQueue() async {
    final box = await queueItemBox;
    return box.values.toList();
  }

  @override
  Future<PlayQueueItem> getPlayQueueItem(Episode episode) async {
    final box = await queueItemBox;
    return box.values.firstWhere(
      (queueItem) => queueItem.episodeId == episode.id,
    );
  }

  final _episodesUpdatedChangeNotifier = ChangeNotifier();

  @override
  Listenable get episodesUpdated => _episodesUpdatedChangeNotifier;

  final _userPodcastSubscriptionsChangeNotifier = ChangeNotifier();

  @override
  Listenable get userPodcastSubscriptionsChanges =>
      _userPodcastSubscriptionsChangeNotifier;

  @override
  Future<List<PodcastImpl>> getPodcasts() async {
    final box = await podcastBox;
    return box.values.toList()..sortedBy((podcast) => podcast.title);
  }

  @override
  Future<List<PodcastWithStatus>> getPodcastsWithCount() async {
    final podcastBox = await this.podcastBox;
    final userEpisodeStatusBox = await this.userEpisodeStatusBox;
    final episodeBox = await this.episodeBox;

    final lastSeenBox = await this.lastSeenBox;

    return <PodcastWithStatus>[
      for (final podcast in podcastBox.values)
        if (episodeBox.values.where(
              (episode) => episode.podcastId == podcast.id,
            )
            case final episodesForPodcast)
          PodcastWithStatus(
            podcast: podcast,
            listenedEpisodes: episodesForPodcast
                .map((episode) => userEpisodeStatusBox.get(episode.id))
                .nonNulls
                .length,
            totalEpisodes: episodesForPodcast.length,
            hasUnseenEpisodes:
                lastSeenBox.get(podcast.id)?.isBefore(podcast.lastPublished) ??
                true,
          ),
    ];
  }

  @override
  Future<UserEpisodeStatusImpl> getUserEpisodeStatus(Episode episode) async {
    final box = await userEpisodeStatusBox;
    return box.get(episode.id) ??
        UserEpisodeStatusImpl.usingEpisodeId(
          episodeId: episode.id,
          isPlayed: false,
          currentPosition: Duration.zero,
        );
  }

  @override
  Future<void> refreshPodcast(PodcastRssUrl podcast) {
    return subscribeToPodcast(podcast);
  }

  @override
  Future<void> subscribeToPodcast(PodcastRssUrl podcast) async {
    final response = await dio.getUri<String>(podcast.url);

    final document = response.data;
    if (document == null) {
      throw Exception('Failed to load podcast');
    }
    final rssPodcast = RssPodcast.fromXmlString(document, podcast.url);

    final podcastImpl = PodcastImpl.fromRssPodcast(rssPodcast);

    final episodes = rssPodcast.episodes
        .map(
          (item) => EpisodeImpl.fromRssEpisode(
            rssEpisode: item,
            podcast: podcastImpl,
          ),
        )
        .toList();

    final podcastBox = await this.podcastBox;
    final episodeBox = await this.episodeBox;

    await podcastBox.put(podcastImpl.id, podcastImpl);
    await episodeBox.putAll({
      for (final episode in episodes) episode.id: episode,
    });
  }

  @override
  Future<void> unsubscribeFromPodcast(PodcastRssUrl podcastUrl) async {
    final podcastBox = await this.podcastBox;
    final episodeBox = await this.episodeBox;

    final podcast = podcastBox.get(podcastUrl);
    if (podcast == null) {
      return;
    }

    await podcastBox.delete(podcast.id);
    await episodeBox.deleteAll(
      episodeBox.values
          .where((episode) => episode.podcastId == podcast.id)
          .map((episode) => episode.id),
    );
  }

  @override
  Future<void> updateLastSeenPodcast(PodcastId podcast) async {
    final box = await lastSeenBox;
    await box.put(podcast, DateTime.now());
  }

  @override
  Stream<List<EpisodeImpl>> watchEpisodesFor({
    required PodcastId podcast,
  }) async* {
    final box = await episodeBox;
    final episodes = box.values
        .where((episode) => episode.podcastId == podcast)
        .toList(growable: false)
        .sortedByCompare(
          (episode) => episode.datePublished,
          (a, b) => b.compareTo(a),
        );
    yield episodes;

    await for (final values in box.stream()) {
      final episodes = values.where((episode) => episode.podcastId == podcast);
      yield episodes
          .toList(growable: false)
          .sortedByCompare(
            (episode) => episode.datePublished,
            (a, b) => b.compareTo(a),
          );
    }
  }

  @override
  Stream<List<PlayQueueItem>> watchPlayQueue() async* {
    final box = await queueItemBox;
    yield box.values.toList(growable: false);

    await for (final values in box.stream()) {
      final queueItems = values.toList(growable: false)
        ..sortBy((queueItem) => queueItem.queueOrder);
      yield queueItems;
    }
  }

  @override
  Stream<List<PodcastImpl>> watchPodcasts() async* {
    final box = await podcastBox;
    yield box.values.toList(growable: false);

    await for (final values in box.stream()) {
      final podcasts = values.toList(growable: false)
        ..sortBy((podcast) => podcast.title);
      yield podcasts;
    }
  }

  @override
  Stream<List<UserEpisodeStatus>> watchUserEpisodeStatus() async* {
    final box = await userEpisodeStatusBox;
    yield box.values.toList(growable: false);

    await for (final values in box.stream()) {
      final statuses = values.toList(growable: false);
      yield statuses;
    }
  }

  @override
  Future<void> markEpisodeListened(
    EpisodeWithStatus episodeWithStatus, {
    bool isPlayed = true,
  }) async {
    final box = await userEpisodeStatusBox;

    final newStatus = switch (episodeWithStatus.status) {
      UserEpisodeStatus(:final episodeId, :final currentPosition) =>
        UserEpisodeStatusImpl.usingEpisodeId(
          episodeId: episodeId,
          currentPosition: currentPosition,
          isPlayed: isPlayed,
        ),
      null => UserEpisodeStatusImpl.usingEpisodeId(
        episodeId: episodeWithStatus.episode.id,
        isPlayed: isPlayed,
        currentPosition: Duration.zero,
      ),
    };
    await box.put(newStatus.episodeHiveId, newStatus);
  }

  @override
  Future<void> updateEpisodePosition(Episode episode, Duration position) async {
    final newStatus = (await getUserEpisodeStatus(
      episode,
    )).copyWith(currentPosition: position);

    final box = await userEpisodeStatusBox;
    await box.put(newStatus.episodeHiveId, newStatus);
  }

  @override
  Future<void> updatePlayQueueItemPosition(
    covariant EpisodeImpl episode,
    int position,
  ) async {
    final box = await queueItemBox;
    final queueItem = PlayQueueItem(episode: episode, queueOrder: position);
    await box.put(queueItem.episodeHiveId, queueItem);
  }
}

extension<T> on Box<T> {
  Stream<Iterable<T>> stream() {
    late StreamController<Iterable<T>> controller;
    final valueListenable = listenable();

    void listener() {
      controller.add(values);
    }

    void start() {
      valueListenable.addListener(listener);
    }

    void end() {
      valueListenable.removeListener(listener);
      controller.close();
    }

    controller = StreamController<Iterable<T>>(
      onListen: start,
      onPause: end,
      onResume: start,
      onCancel: end,
    );

    return controller.stream;
  }
}
