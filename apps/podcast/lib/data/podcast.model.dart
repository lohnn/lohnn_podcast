// Your model definition can live anywhere in lib/**/* as long as it has the .model.dart suffix
// Assume this file is saved at my_app/lib/src/users/user.model.dart

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast/data/serdes/uri_model.dart';
import 'package:podcast_core/data/podcast.model.dart' as core;

part 'podcast.model.mapper.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'podcasts'),
)
@MappableClass(caseStyle: CaseStyle.snakeCase)
class Podcast extends OfflineFirstWithSupabaseModel
    with PodcastMappable
    implements core.Podcast {
  @override
  @Supabase(unique: true, name: 'rss_url')
  @Sqlite(index: true, unique: true)
  @MappableField(key: 'rss_url')
  final String id;
  @override
  final String name;
  @override
  final String link;
  @override
  final String description;
  @Supabase(name: 'image_url')
  final UriModel backingImageUrl;
  @override
  final String? language;
  @override
  final String? lastBuildDate;
  @override
  final String? copyright;
  @override
  final String? generator;

  @override
  @Supabase(ignore: true)
  String get rssUrl => id;

  @override
  @Supabase(ignore: true)
  Uri get rssUri => Uri.parse(id);

  /// A safe ID that can be used as path and query parameters
  @override
  @Supabase(ignore: true)
  String get safeId => Uri.encodeComponent(id);

  Podcast({
    required this.id,
    required this.name,
    required this.link,
    required this.description,
    required this.backingImageUrl,
    this.language,
    this.lastBuildDate,
    this.copyright,
    this.generator,
  });

  @override
  @Supabase(ignore: true)
  Uri get imageUrl => backingImageUrl.uri;
}
