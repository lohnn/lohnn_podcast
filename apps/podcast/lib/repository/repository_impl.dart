import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:podcast/data/episode_impl.model.dart';
import 'package:podcast/data/play_queue_item.model.dart';
import 'package:podcast/data/podcast_search.model.dart';
import 'package:podcast/data/user_episode_status_impl.model.dart';
import 'package:podcast/repository/adapters/hive_registrar.g.dart';
import 'package:podcast/repository/search_headers_interceptor.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/data/episode_with_status.dart';
import 'package:podcast_core/data/podcast_with_status.dart';
import 'package:podcast_core/data/user_episode_status.model.dart';
import 'package:podcast_core/repository.dart' as core;

class RepositoryImpl implements core.Repository {
  factory RepositoryImpl() {
    final podcastIndexDio = Dio(
      BaseOptions(baseUrl: 'https://api.podcastindex.org/api/1.0/'),
    );
    podcastIndexDio.interceptors.add(const SearchHeadersInterceptor());
    return RepositoryImpl._(podcastIndexDio: podcastIndexDio)..init();
  }

  RepositoryImpl._({required this.podcastIndexDio});

  final Dio podcastIndexDio;

  Future<Box<PodcastSearch>> get podcastBox => Hive.openBox('podcastBox');

  Future<Box<PlayQueueItem>> get queueItemBox => Hive.openBox('queueItemBox');

  Future<Box<EpisodeImpl>> get episodeBox => Hive.openBox('episodeBox');

  Future<Box<UserEpisodeStatusImpl>> get userEpisodeStatusBox =>
      Hive.openBox('userEpisodeStatusBox');

  void init() {
    Hive
      ..init(Directory.current.path)
      ..registerAdapters();
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
          (feed) => PodcastSearchMapper.fromMap(feed as Map<String, dynamic>),
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

  // TODO: watchTableProvider('episodes', event: PostgresChangeEvent.insert);
  final _episodeChangeNotifier = ChangeNotifier();

  @override
  ChangeNotifier get episodesInserted => _episodeChangeNotifier;

  @override
  Future<List<PodcastSearch>> getPodcasts() async {
    final box = await podcastBox;
    return box.values.toList()..sortedBy((podcast) => podcast.title);
  }

  @override
  Future<List<PodcastWithStatus>> getPodcastsWithCount() async {
    final podcastBox = await this.podcastBox;
    final userEpisodeStatusBox = await this.userEpisodeStatusBox;
    final episodeBox = await this.episodeBox;

    return <PodcastWithStatus>[
      for (final podcast in podcastBox.values)
        if (episodeBox.values.where(
              (episode) => episode.podcastId == podcast.id,
            )
            case final episodesForPodcast)
          PodcastWithStatus(
            podcast: podcast,
            listenedEpisodes:
                episodesForPodcast
                    .map((episode) => userEpisodeStatusBox.get(episode.hiveId))
                    .nonNulls
                    .length,
            totalEpisodes: episodesForPodcast.length,
            // TODO: Store when podcast was last seen somwhere
            hasUnseenEpisodes: false,
          ),
    ];
  }

  @override
  Future<UserEpisodeStatusImpl> getUserEpisodeStatus(
    covariant EpisodeImpl episode,
  ) async {
    final box = await userEpisodeStatusBox;
    return box.get(episode.hiveId) ??
        UserEpisodeStatusImpl.usingEpisodeId(
          episodeId: episode.id,
          isPlayed: false,
          currentPosition: Duration.zero,
        );
  }

  @override
  Future<void> refreshPodcast(covariant PodcastSearch podcast) {
    return subscribeToPodcast(podcast);
  }

  @override
  Future<void> subscribeToPodcast(covariant PodcastSearch podcast) async {
    final response = await podcastIndexDio.get<Map<String, dynamic>>(
      '/episodes/byfeedurl',
      queryParameters: {'url': podcast.backingUrl, 'max': 1000},
    );

    final {'items': List<dynamic> items} = response.data!;

    final episodes =
        items
            .map(
              (item) => EpisodeImplMapper.fromMap({
                ...(item as Map<String, dynamic>),
                'podcastId': podcast.id,
              }),
            )
            .toList();

    final podcastBox = await this.podcastBox;
    final episodeBox = await this.episodeBox;

    await podcastBox.put(podcast.hiveId, podcast);
    await episodeBox.putAll({
      // TODO: Hive can only store int ids of at most 0xffffffff 🤔
      for (final episode in episodes) episode.hiveId: episode,
    });
  }

  @override
  Future<void> unsubscribeFromPodcast(covariant PodcastSearch podcast) async {
    final podcastBox = await this.podcastBox;
    final episodeBox = await this.episodeBox;

    await podcastBox.delete(podcast.hiveId);
    await episodeBox.deleteAll(
      episodeBox.values
          .where((episode) => episode.podcastId == podcast.id)
          .map((episode) => episode.hiveId),
    );
  }

  @override
  Future<void> updateLastSeenPodcast(covariant PodcastSearch podcast) async {
    // return remoteProvider.client.rpc(
    //   'update_last_seen',
    //   params: {'podcast_id': podcast.id},
    // );
  }

  // TODO: watchTableProvider('user_podcast_subscriptions');
  final _userPodcastSubscriptionsChangeNotifier = ChangeNotifier();

  @override
  ChangeNotifier get userPodcastSubscriptionsChanges =>
      _userPodcastSubscriptionsChangeNotifier;

  @override
  Stream<List<EpisodeImpl>> watchEpisodesFor({
    required PodcastId podcastId,
  }) async* {
    final box = await episodeBox;
    final episodes = box.values
        .where((episode) => episode.podcastId == podcastId)
        .toList(growable: false)
        .sortedByCompare(
          (episode) => episode.datePublished,
          (a, b) => b.compareTo(a),
        );
    yield episodes;

    await for (final values in box.stream()) {
      final episodes = values.where(
        (episode) => episode.podcastId == podcastId,
      );
      yield episodes
          .toList(growable: false)
          .sortedByCompare(
            (episode) => episode.datePublished,
            (a, b) => b.compareTo(a),
          );
      ;
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
  Stream<List<PodcastSearch>> watchPodcasts() async* {
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
      UserEpisodeStatus(
        :final episodeId,
        :final currentPosition,
        :final isPlayed,
      ) =>
        UserEpisodeStatusImpl.usingEpisodeId(
          episodeId: episodeId,
          currentPosition: currentPosition,
          isPlayed: isPlayed,
        ),
      null => UserEpisodeStatusImpl.usingEpisodeId(
        episodeId: episodeWithStatus.episode.id,
        isPlayed: false,
        currentPosition: Duration.zero,
      ),
    };
    await box.put(newStatus.episodeHiveId, newStatus);
  }

  @override
  Future<void> updateEpisodePosition(
    covariant EpisodeImpl episode,
    Duration position,
  ) async {
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
