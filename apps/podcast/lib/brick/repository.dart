// Saved in my_app/lib/src/brick/repository.dart
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:brick_offline_first/mixins.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_sqlite/memory_cache_provider.dart';
// This hide is for Brick's @Supabase annotation; in most cases,
// supabase_flutter **will not** be imported in application code.
import 'package:brick_supabase/brick_supabase.dart' hide Supabase;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/brick/brick.g.dart';
import 'package:podcast/brick/db/schema.g.dart';
import 'package:podcast/data/episode_impl.model.dart';
import 'package:podcast/data/play_queue_item.model.dart';
import 'package:podcast/data/podcast.model.dart';
import 'package:podcast/data/podcast_search.model.dart';
import 'package:podcast/data/serdes/duration_model.dart';
import 'package:podcast/data/user_episode_status_impl.model.dart';
import 'package:podcast/extensions/future_extensions.dart';
import 'package:podcast/secrets.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/data/episode_with_status.dart';
import 'package:podcast_core/data/podcast_with_status.dart';
import 'package:podcast_core/data/user_episode_status.model.dart';
import 'package:podcast_core/providers/app_lifecycle_state_provider.dart';
import 'package:podcast_core/repository.dart' as core;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'repository.g.dart';

class RepositoryImpl extends OfflineFirstWithSupabaseRepository
    with DestructiveLocalSyncFromRemoteMixin
    implements core.Repository {
  static late RepositoryImpl? _instance;

  factory RepositoryImpl() => _instance!;

  RepositoryImpl._({
    required super.supabaseProvider,
    required super.sqliteProvider,
    required super.migrations,
    required super.offlineRequestQueue,
    super.memoryCacheProvider,
  });

  static Future<void> configure(DatabaseFactory databaseFactory) async {
    final (client, queue) = OfflineFirstWithSupabaseRepository.clientQueue(
      databaseFactory: databaseFactory,
      reattemptForStatusCodes: const [
        400,
        403,
        404,
        405,
        408,
        409,
        429,
        500,
        502,
        503,
        504,
      ],
    );

    await Supabase.initialize(
      url: Secrets.supabaseUrl,
      anonKey: Secrets.supabaseAnonKey,
      httpClient: client,
    );

    final provider = SupabaseProvider(
      Supabase.instance.client,
      modelDictionary: supabaseModelDictionary,
    );

    // This is used to separate the SQLite database file between local and remote
    const sqlSuffix = String.fromEnvironment('SQL_SUFFIX', defaultValue: '2');

    _instance = RepositoryImpl._(
      supabaseProvider: provider,
      sqliteProvider: SqliteProvider(
        'podcast$sqlSuffix.sqlite',
        databaseFactory: databaseFactory,
        modelDictionary: sqliteModelDictionary,
      ),
      migrations: migrations,
      offlineRequestQueue: queue,
      // Specify class types that should be cached in memory
      memoryCacheProvider: MemoryCacheProvider(),
    );
  }

  Future<void> upsertLocalIterable<
    TModel extends OfflineFirstWithSupabaseModel
  >(Iterable<TModel> instances, {Query? query}) {
    return instances.map(upsertLocal).wait;
  }

  Future<void> upsertLocal<TModel extends OfflineFirstWithSupabaseModel>(
    TModel instance, {
    Query? query,
  }) async {
    final modelId = await sqliteProvider.upsert<TModel>(
      instance,
      query: query,
      repository: this,
    );
    instance.primaryKey = modelId;
    memoryCacheProvider.upsert<TModel>(instance, query: query);
    await notifySubscriptionsWithLocalData<TModel>();
  }

  RealtimeChannel watchTable(
    String table,
    void Function(PostgresChangePayload payload) callback, {
    PostgresChangeEvent? event,
    PostgresChangeFilter? filter,
  }) {
    return remoteProvider.client
        .channel(table)
        .onPostgresChanges(
          event: event ?? PostgresChangeEvent.all,
          schema: 'public',
          table: table,
          filter: filter,
          callback: callback,
        )
        .subscribe();
  }

  @override
  Future<List<PodcastSearch>> findPodcasts([String? searchTerm]) async {
    final response = await remoteProvider.client.functions.invoke(
      'find_podcasts',
      body: searchTerm,
    );
    final data = (response.data as List<dynamic>).cast<Map<String, dynamic>>();
    return data.map(PodcastSearchMapper.fromMap).toList(growable: false);
  }

  @override
  Future<void> checkInUser() async {
    await remoteProvider.client.rpc('check_in_user');
  }

  @override
  Future<void> deletePlayQueueItem(covariant PlayQueueItem queueItem) {
    return delete<PlayQueueItem>(queueItem);
  }

  @override
  Future<List<PlayQueueItem>> getPlayQueue() {
    return get<PlayQueueItem>(forceLocalSyncFromRemote: true);
  }

  @override
  Future<PlayQueueItem> getPlayQueueItem(Episode episode) {
    return get<PlayQueueItem>(
      query: Query.where('episodeId', episode.id),
    ).single;
  }

  @override
  ProviderListenable<Object?> get episodesInsertedProvider =>
      watchTableProvider('episodes', event: PostgresChangeEvent.insert);

  final _getPodcastsQuery = const Query(orderBy: [OrderBy('name')]);

  @override
  Future<List<Podcast>> getPodcasts() {
    return get<Podcast>(
      forceLocalSyncFromRemote: true,
      query: _getPodcastsQuery,
    );
  }

  @override
  Future<List<PodcastWithStatus>> getPodcastsWithCount() async {
    final podcastsWithCount = await remoteProvider.client
        .rpc<List<Map<String, dynamic>>>('podcast_with_count');

    return <PodcastWithStatus>[
      for (final podcast in podcastsWithCount)
        if (podcast case {
          'podcast_id': final String podcastId,
          'episode_count': final int episodeCount,
          'played_episode_count': final int playedEpisodeCount,
          'has_unseen_episodes': final bool hasUnseenEpisodes,
        })
          PodcastWithStatus(
            podcast: (await getPodcasts()).firstWhere(
              (podcast) => podcast.id == podcastId,
            ),
            listenedEpisodes: playedEpisodeCount,
            totalEpisodes: episodeCount,
            hasUnseenEpisodes: hasUnseenEpisodes,
          ),
    ];
  }

  @override
  Future<UserEpisodeStatusImpl> getUserEpisodeStatus(String episodeId) async {
    return (await get<UserEpisodeStatusImpl>(
          query: Query.where('episodeId', episodeId),
        ).firstOrNull) ??
        UserEpisodeStatusImpl(
          episodeId: episodeId,
          isPlayed: false,
          backingCurrentPosition: DurationModel(Duration.zero),
        );
  }

  @override
  Future<void> refreshPodcast(String rssUrl) {
    return remoteProvider.client.functions.invoke('add_podcast', body: rssUrl);
  }

  @override
  Future<void> subscribeToPodcast(String rssUrl) {
    return remoteProvider.client.functions.invoke(
      'subscribe_to_podcast',
      body: rssUrl,
    );
  }

  @override
  Future<void> unsubscribeFromPodcast(String rssUrl) {
    return remoteProvider.client.functions.invoke(
      'unsubscribe_from_podcast',
      body: rssUrl,
    );
  }

  @override
  Future<void> updateLastSeenPodcast(covariant Podcast podcast) {
    return remoteProvider.client.rpc(
      'update_last_seen',
      params: {'podcast_id': podcast.id},
    );
  }

  @override
  ProviderListenable<Object?> get userPodcastSubscriptionsChangesProvider =>
      watchTableProvider('user_podcast_subscriptions');

  @override
  Stream<List<Episode>> watchEpisodesFor({required String podcastId}) {
    final query = Query(
      where: [Where('podcastId', value: podcastId)],
      orderBy: [const OrderBy('pubDate', ascending: false)],
      // @TODO: Look into adding pagination
    );
    return subscribeToRealtime<EpisodeImpl>(query: query);
  }

  @override
  Stream<List<PlayQueueItem>> watchPlayQueue() {
    return subscribe<PlayQueueItem>(
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      query: const Query(orderBy: [OrderBy('queueOrder')]),
    );
  }

  @override
  Stream<List<Podcast>> watchPodcasts() {
    return subscribeToRealtime<Podcast>(
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      query: _getPodcastsQuery,
    );
  }

  @override
  Stream<List<UserEpisodeStatus>> watchUserEpisodeStatus() {
    return subscribeToRealtime<UserEpisodeStatusImpl>();
  }

  @override
  Future<void> markEpisodeListened(
    EpisodeWithStatus episodeWithStatus, {
    bool isPlayed = true,
  }) {
    final newStatus = switch (episodeWithStatus.status) {
      UserEpisodeStatus(
        :final episodeId,
        :final currentPosition,
        :final isPlayed,
      ) =>
        UserEpisodeStatusImpl(
          episodeId: episodeId,
          backingCurrentPosition: DurationModel(currentPosition),
          isPlayed: isPlayed,
        ),
      null => UserEpisodeStatusImpl(
        episodeId: episodeWithStatus.episode.id,
        isPlayed: false,
        backingCurrentPosition: DurationModel(Duration.zero),
      ),
    };
    return upsert<UserEpisodeStatusImpl>(
      newStatus.copyWith(isPlayed: isPlayed),
    );
  }

  @override
  Future<void> updateEpisodePosition(Episode episode, Duration position) async {
    final newStatus = (await getUserEpisodeStatus(
      episode.id,
    )).copyWith(backingCurrentPosition: DurationModel(position));

    await upsert<UserEpisodeStatusImpl>(newStatus);
  }

  @override
  Future<void> updatePlayQueueItemPosition(
    covariant EpisodeImpl episode,
    int position,
  ) {
    return upsert<PlayQueueItem>(
      PlayQueueItem(episode: episode, queueOrder: position),
    );
  }
}

@riverpod
PostgresChangePayload? watchTable(
  WatchTableRef ref,
  String table, {
  PostgresChangeEvent event = PostgresChangeEvent.all,
}) {
  final lifecycleState = ref.watch(appLifecycleStatePodProvider);
  if (lifecycleState != AppLifecycleState.resumed) return null;

  final channel = RepositoryImpl().watchTable(
    table,
    event: event,
    (payload) => ref.state = payload,
  );
  ref.onDispose(channel.unsubscribe);

  return null;
}
