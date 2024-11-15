import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:podcast/brick/repository.dart';
import 'package:podcast/data/podcast.model.dart';
import 'package:podcast/providers/socket_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'podcasts_provider.g.dart';

@riverpod
Future<Podcast> podcast(PodcastRef ref, String podcastId) async {
  return ref.watch(
    podcastsProvider.selectAsync(
      (podcasts) => podcasts.firstWhere((podcast) => podcast.id == podcastId),
    ),
  );
}

@riverpod
class Podcasts extends _$Podcasts {
  final _query = Query(providerArgs: {'orderBy': 'name ASC'});

  @override
  Stream<List<Podcast>> build() async* {
    final socketOpen = ref.watch(socketPodProvider);
    if (!socketOpen) return;

    keepUpToDateWithSubscriptions();
    // Force a clean refresh on startup to clear out any stored rows that may
    // have been deleted
    _syncWithRemote();
    yield* Repository().subscribeToRealtime<Podcast>(
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      query: _query,
    );
  }

  /// Listens to the `user_podcast_subscriptions` table, that is used to store
  /// the user's subscriptions to podcasts. When the table is updated, the
  /// podcast list is updated.
  void keepUpToDateWithSubscriptions() {
    final channel = Repository()
        .remoteProvider
        .client
        .channel('user_podcast_subscriptions')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'user_podcast_subscriptions',
          callback: (_) => _syncWithRemote(),
        )
        .subscribe();

    ref.onDispose(channel.unsubscribe);
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
          'add_podcasts',
          body: podcasts.map((e) => e.rssUrl),
        );
  }

  Future<void> addPodcastToList(String rssUrl) {
    return Repository().remoteProvider.client.functions.invoke(
          'add_podcast',
          body: rssUrl,
        );
  }
}
