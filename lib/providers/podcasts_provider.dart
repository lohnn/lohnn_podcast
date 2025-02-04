import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:podcast/brick/repository.dart';
import 'package:podcast/data/podcast.model.dart';
import 'package:podcast/helpers/equatable_list.dart';
import 'package:podcast/providers/app_lifecycle_state_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'podcasts_provider.g.dart';

@riverpod
class PodcastPod extends _$PodcastPod {
  @override
  Future<Podcast> build(String podcastId) async {
    return ref.watch(
      podcastsProvider.selectAsync(
        (podcasts) => podcasts.firstWhere((podcast) => podcast.id == podcastId),
      ),
    );
  }

  Future<void> updateLastSeen() async {
    final podcast = await future;
    return Repository().remoteProvider.client.rpc(
      'update_last_seen',
      params: {'podcast_id': podcast.id},
    );
  }
}

@riverpod
class Podcasts extends _$Podcasts {
  final _query = const Query(orderBy: [OrderBy('name')]);

  @override
  Stream<EquatableList<Podcast>> build() async* {
    final lifecycleState = ref.watch(appLifecycleStatePodProvider);
    if (lifecycleState != AppLifecycleState.resumed) return;

    keepUpToDateWithSubscriptions();
    // Force a clean refresh on startup to clear out any stored rows that may
    // have been deleted
    _syncWithRemote();
    yield* Repository()
        .subscribeToRealtime<Podcast>(
          policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
          query: _query,
        )
        .map(EquatableList.new);
  }

  /// Listens to the `user_podcast_subscriptions` table, that is used to store
  /// the user's subscriptions to podcasts. When the table is updated, the
  /// podcast list is updated.
  void keepUpToDateWithSubscriptions() {
    ref.listen(
      watchTableProvider('user_podcast_subscriptions'),
      (oldValue, newValue) {
        if (newValue == null) return;
        _syncWithRemote();
      },
    );
  }

  /// Syncs the local database with the remote database, using force local sync,
  /// that clears the local database of rows that have been deleted remotely.
  Future<void> _syncWithRemote() {
    return Repository().get<Podcast>(
      forceLocalSyncFromRemote: true,
      query: _query,
    );
  }

  Future<void> refresh(Podcast podcast) {
    return addPodcastToList(podcast.rssUrl);
  }

  Future<void> refreshAll() async {
    final podcasts = await future;
    await Repository().remoteProvider.client.functions.invoke(
          'add_podcast_list',
          body: podcasts.map((e) => e.rssUrl).toList(),
        );
  }

  Future<void> addPodcastToList(String rssUrl) {
    return Repository().remoteProvider.client.functions.invoke(
          'add_podcast',
          body: rssUrl,
        );
  }
}
