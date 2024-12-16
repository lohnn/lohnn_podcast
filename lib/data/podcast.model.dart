// Your model definition can live anywhere in lib/**/* as long as it has the .model.dart suffix
// Assume this file is saved at my_app/lib/src/users/user.model.dart

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast/data/serdes/uri_model.dart';

part 'podcast.model.mapper.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(
    tableName: 'podcasts',
  ),
)
@MappableClass(caseStyle: CaseStyle.snakeCase)
class Podcast extends OfflineFirstWithSupabaseModel
    with PodcastMappable {
  @Supabase(unique: true, name: 'rss_url')
  @Sqlite(index: true, unique: true)
  @MappableField(key: 'rss_url')
  final String id;
  final String name;
  final String link;
  final String description;
  @MappableField()
  final UriModel imageUrl;
  final String? language;
  final String? lastBuildDate;
  final String? copyright;
  final String? generator;

  @Supabase(ignore: true)
  String get rssUrl => id;

  /// A safe ID that can be used as path and query parameters
  @Supabase(ignore: true)
  String get safeId => Uri.encodeComponent(id);

  Podcast({
    required this.id,
    required this.name,
    required this.link,
    required this.description,
    required this.imageUrl,
    this.language,
    this.lastBuildDate,
    this.copyright,
    this.generator,
  });
}
