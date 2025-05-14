import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:podcast_core/data/podcast.model.dart';
import 'package:podcast_core/extensions/ref_extensions.dart';
import 'package:podcast_core/helpers/equatable_list.dart';
import 'package:podcast_core/providers/app_lifecycle_state_provider.dart';
import 'package:podcast_core/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'podcasts_provider.g.dart';

@riverpod
Future<bool?> subscribedPodcast(
  Ref ref, {
  required PodcastRssUrl rssUrl,
}) async {
  return ref
      .watch(_subscribedPodcastRssUrlsProvider)
      .value
      ?.contains(rssUrl);
}

@riverpod
Future<Iterable<PodcastRssUrl>?> _subscribedPodcastRssUrls(
  Ref ref,
) async {
  return ref
      .watch(
        podcastsProvider.select(
          (state) => state.whenData(
            (podcasts) => podcasts.map((podcast) => podcast.url),
          ),
        ),
      )
      .value;
}

@riverpod
class PodcastPod extends _$PodcastPod {
  late Repository _repository;

  @override
  Future<Podcast> build(PodcastId podcastId) async {
    _repository = ref.watch(repositoryProvider);
    return ref.watch(
      podcastsProvider.selectAsync(
        (podcasts) => podcasts.firstWhere((podcast) => podcast.id == podcastId),
      ),
    );
  }

  Future<void> updateLastSeen() async {
    final podcast = await future;
    return _repository.updateLastSeenPodcast(podcast.id);
  }
}

@riverpod
class Podcasts extends _$Podcasts {
  late Repository _repository;

  @override
  Stream<EquatableList<Podcast>> build() async* {
    _repository = ref.watch(repositoryProvider);
    final lifecycleState = ref.watch(appLifecycleStatePodProvider);
    if (lifecycleState != AppLifecycleState.resumed) return;

    keepUpToDateWithSubscriptions();
    // Force a clean refresh on startup to clear out any stored rows that may
    // have been deleted
    unawaited(_syncWithRemote());
    yield* _repository.watchPodcasts().map(EquatableList.new);
  }

  /// Listens to the `user_podcast_subscriptions` table, that is used to store
  /// the user's subscriptions to podcasts. When the table is updated, the
  /// podcast list is updated.
  void keepUpToDateWithSubscriptions() {
    ref.listenListenable(
      _repository.userPodcastSubscriptionsChanges,
      _syncWithRemote,
    );
  }

  /// Syncs the local database with the remote database, using force local sync,
  /// that clears the local database of rows that have been deleted remotely.
  Future<void> _syncWithRemote() {
    return _repository.getPodcasts();
  }

  Future<void> refresh(Podcast podcast) {
    return _repository.refreshPodcast(podcast.url);
  }

  Future<void> subscribe(PodcastRssUrl podcast) async {
    final oldState = state;
    state = const AsyncLoading();
    try {
      await _repository.subscribeToPodcast(podcast);
    } catch (e, stackTrace) {
      debugPrint('Error subscribing to podcast: $e');
      debugPrintStack(stackTrace: stackTrace);
      state = oldState;
    }
  }

  Future<void> unsubscribe(PodcastRssUrl podcast) {
    state = const AsyncLoading();
    return _repository.unsubscribeFromPodcast(podcast);
  }
}
