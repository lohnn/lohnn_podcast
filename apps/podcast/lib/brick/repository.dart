// Saved in my_app/lib/src/brick/repository.dart
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:brick_offline_first/mixins.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_sqlite/memory_cache_provider.dart';
// This hide is for Brick's @Supabase annotation; in most cases,
// supabase_flutter **will not** be imported in application code.
import 'package:brick_supabase/brick_supabase.dart' hide Supabase;
import 'package:podcast/brick/brick.g.dart';
import 'package:podcast/brick/db/schema.g.dart';
import 'package:podcast/data/podcast_search.model.dart';
import 'package:podcast/providers/app_lifecycle_state_provider.dart';
import 'package:podcast/secrets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'repository.g.dart';

class Repository extends OfflineFirstWithSupabaseRepository
    with DestructiveLocalSyncFromRemoteMixin {
  static late Repository? _instance;

  factory Repository() => _instance!;

  Repository._({
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
    const sqlSuffix = String.fromEnvironment('SQL_SUFFIX');

    _instance = Repository._(
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

  Future<List<PodcastSearch>> findPodcasts([String? searchTerm]) async {
    final response = await remoteProvider.client.functions.invoke(
      'find_podcasts',
      body: searchTerm,
    );
    final data = (response.data as List<dynamic>).cast<Map<String, dynamic>>();
    return data.map(PodcastSearchMapper.fromMap).toList(growable: false);
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

  final channel = Repository().watchTable(
    table,
    event: event,
    (payload) => ref.state = payload,
  );
  ref.onDispose(channel.unsubscribe);

  return null;
}
