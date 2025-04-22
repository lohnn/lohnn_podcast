import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast/data/serdes/duration_model.dart';
import 'package:podcast/data/serdes/uri_model.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/services/podcast_audio_handler.dart';

part 'episode_impl.model.mapper.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'episodes'),
)
@MappableClass()
class EpisodeImpl extends OfflineFirstWithSupabaseModel
    with EpisodeImplMappable
    implements Episode {
  @override
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;
  @Supabase(name: 'url')
  final UriModel backingUrl;
  @override
  final String title;
  @override
  final DateTime? pubDate;
  @override
  final String? description;
  @Supabase(name: 'image_url')
  final UriModel backingImageUrl;
  @Supabase(name: 'duration')
  final DurationModel? backingDuration;
  @override
  @Supabase(foreignKey: 'podcast_id')
  final String podcastId;

  EpisodeImpl({
    required this.id,
    required this.backingUrl,
    required this.title,
    this.pubDate,
    this.description,
    required this.backingImageUrl,
    this.backingDuration,
    required this.podcastId,
  });

  @override
  @Supabase(ignore: true)
  String get safeId => Uri.encodeComponent(id);

  @override
  @Supabase(ignore: true)
  String get safePodcastId => Uri.encodeComponent(podcastId);

  @override
  @Supabase(ignore: true)
  String get localFilePath => '$safeId-${url.pathSegments.last}';

  @override
  PodcastMediaItem mediaItem({
    Duration? actualDuration,
    bool? isPlayingFromDownloaded,
  }) {
    return PodcastMediaItem(
      episode: this,
      // @TODO: This should be able to use the local URL as well?
      id: url.toString(),
      title: title,
      artUri: imageUrl,
      duration: actualDuration ?? duration,
    );
  }

  @override
  @Supabase(ignore: true)
  Uri get imageUrl => backingImageUrl.uri;

  @override
  @Supabase(ignore: true)
  Uri get url => backingUrl.uri;

  @override
  @Supabase(ignore: true)
  Duration? get duration => backingDuration?.duration;
}
