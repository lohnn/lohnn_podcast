// Saved in my_app/lib/src/brick/repository.dart
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_sqlite/memory_cache_provider.dart';
// This hide is for Brick's @Supabase annotation; in most cases,
// supabase_flutter **will not** be imported in application code.
import 'package:brick_supabase/brick_supabase.dart' hide Supabase;
import 'package:podcast/brick/brick.g.dart';
import 'package:podcast/brick/db/schema.g.dart';
import 'package:podcast/brick/subscribe_with_channels.dart';
import 'package:sqflite_common/sqlite_api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Repository
    extends OfflineFirstWithSupabaseRepository with SubscribeWithChannels
{
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
    );

    await Supabase.initialize(
      url: const String.fromEnvironment('SUPABASE_URL'),
      anonKey: const String.fromEnvironment('ANON_KEY'),
      httpClient: client,
    );

    final provider = SupabaseProvider(
      Supabase.instance.client,
      modelDictionary: supabaseModelDictionary,
    );

    _instance = Repository._(
      supabaseProvider: provider,
      sqliteProvider: SqliteProvider(
        'podcast.sqlite',
        databaseFactory: databaseFactory,
        modelDictionary: sqliteModelDictionary,
      ),
      migrations: migrations,
      offlineRequestQueue: queue,
      // Specify class types that should be cached in memory
      memoryCacheProvider: MemoryCacheProvider(),
    );
  }
}
