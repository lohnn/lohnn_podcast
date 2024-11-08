import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:podcast/brick/repository.dart';
import 'package:podcast/data/podcast_supabase.model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'podcasts_provider.g.dart';

@riverpod
Future<PodcastSupabase> podcast(PodcastRef ref, String podcastId) async {
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
  Stream<List<PodcastSupabase>> build() {
    keepUpToDateWithSubscriptions();
    // Force a clean refresh on startup to clear out any stored rows that may
    // have been deleted
    _syncWithRemote();
    return Repository().subscribeToRealtime<PodcastSupabase>(
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
    return Repository().get<PodcastSupabase>(
      forceLocalSyncFromRemote: true,
      query: _query,
    );
  }
}
