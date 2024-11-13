// Your model definition can live anywhere in lib/**/* as long as it has the .model.dart suffix
// Assume this file is saved at my_app/lib/src/users/user.model.dart

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast/data/serdes/duration_model.dart';
import 'package:podcast/data/serdes/uri_model.dart';
import 'package:podcast/services/podcast_audio_handler.dart';

part 'episode.model.mapper.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(
    tableName: 'episodes',
  ),
)
@MappableClass()
class Episode extends OfflineFirstWithSupabaseModel with EpisodeMappable {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;
  final UriModel url;
  final String title;
  final DateTime? pubDate;
  final String? description;
  final UriModel imageUrl;
  @Supabase(nullable: true)
  final DurationModel? duration;
  @Supabase(foreignKey: 'podcast_id')
  final String podcastId;

  Episode({
    required this.id,
    required this.url,
    required this.title,
    this.pubDate,
    this.description,
    required this.imageUrl,
    this.duration,
    required this.podcastId,
  });

  PodcastMediaItem mediaItem({
    Duration? actualDuration,
  }) =>
      PodcastMediaItem(
        episode: this,
        id: url.uri.toString(),
        title: title,
        artUri: imageUrl.uri,
        duration: actualDuration ?? duration?.duration,
      );
}
