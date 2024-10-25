// Your model definition can live anywhere in lib/**/* as long as it has the .model.dart suffix
// Assume this file is saved at my_app/lib/src/users/user.model.dart

import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'episode_supabase.model.mapper.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(
    tableName: 'episodes',
    fieldRename: FieldRename.none,
  ),
)
@MappableClass()
class EpisodeSupabase extends OfflineFirstWithSupabaseModel
    with EpisodeSupabaseMappable {
  // Be sure to specify an index that **is not** auto incremented in your table.
  // An offline-first strategy requires distributed clients to create
  // indexes without fear of collision.
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;
  final UriModel url;
  final String title;
  final DateTime? pubDate;
  final String? description;
  final UriModel imageUrl;
  @Supabase(nullable: true)
  final EpisodeDuration? duration;

  // region Dynamic fields
  // @Default(false)
  // final bool listened;

  // @DurationConverter()
  // final Duration? currentPosition;

  EpisodeSupabase({
    required this.id,
    required this.url,
    required this.title,
    this.pubDate,
    this.description,
    required this.imageUrl,
    this.duration,
    // required this.listened,
    // this.currentPosition,
  });
}

String uriToGenerator(Uri url) {
  return url.toString();
}

Uri uriFromGenerator(String url) {
  return Uri.parse(url);
}

int? durationToGenerator(Duration? duration) {
  return duration?.inMilliseconds;
}

Duration? durationFromGenerator(int? milliseconds) {
  if (milliseconds == null) return null;
  return Duration(milliseconds: milliseconds);
}

class EpisodeDuration extends OfflineFirstSerdes<int, int> {
  final Duration duration;

  EpisodeDuration(this.duration);

  factory EpisodeDuration.fromRest(int durationMillis) => EpisodeDuration(
        Duration(milliseconds: durationMillis),
      );

  factory EpisodeDuration.fromSupabase(int durationMillis) {
    return EpisodeDuration(
      Duration(milliseconds: durationMillis),
    );
  }

  factory EpisodeDuration.fromSqlite(int durationMillis) => EpisodeDuration(
        Duration(milliseconds: durationMillis),
      );

  factory EpisodeDuration.fromGraphql(int durationMillis) => EpisodeDuration(
        Duration(milliseconds: durationMillis),
      );

  @override
  int toSqlite() {
    return duration.inMilliseconds;
  }

  @override
  int toSupabase() {
    return duration.inMilliseconds;
  }

  @override
  int toRest() {
    return duration.inMilliseconds;
  }

  @override
  int toGraphql() {
    return duration.inMilliseconds;
  }
}

class UriModel extends OfflineFirstSerdes<String, String> {
  final Uri uri;

  UriModel(this.uri);

  factory UriModel.fromRest(String data) => UriModel(
        Uri.parse(data),
      );

  factory UriModel.fromSupabase(String data) => UriModel(
        Uri.parse(data),
      );

  factory UriModel.fromSqlite(String data) => UriModel(
        Uri.parse(data),
      );

  factory UriModel.fromGraphql(String data) => UriModel(
        Uri.parse(data),
      );

  @override
  String toSqlite() {
    return uri.toString();
  }

  @override
  String toSupabase() {
    return uri.toString();
  }

  @override
  String toRest() {
    return uri.toString();
  }

  @override
  String toGraphql() {
    return uri.toString();
  }
}
