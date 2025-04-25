import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast/data/podcast_impl.model.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/extensions/nullability_extensions.dart';
import 'package:podcast_core/services/podcast_audio_handler.dart';

part 'episode_impl.model.mapper.dart';

@MappableClass()
class EpisodeImpl with EpisodeImplMappable implements Episode {
  @MappableField(key: 'id')
  final int backingId;
  @MappableField(key: 'enclosureUrl')
  final String backingUrl;
  @override
  final String title;
  final int datePublished;
  @override
  final String description;
  @MappableField(key: 'image')
  final String backingImageUrl;
  @MappableField(key: 'duration')
  final int? backingDuration;
  @MappableField(key: 'podcastId')
  final int backingPodcastId;

  EpisodeImpl({
    required this.backingId,
    required this.backingUrl,
    required this.title,
    required this.datePublished,
    required this.description,
    required this.backingImageUrl,
    required this.backingDuration,
    required this.backingPodcastId,
  });

  @override
  EpisodeId get id => EpisodeId(backingId);

  String get hiveId => id.toString();

  @override
  Uri get url => Uri.parse(backingUrl);

  @override
  DateTime get pubDate =>
      DateTime.fromMillisecondsSinceEpoch(datePublished * 1000);

  @override
  String get localFilePath => '$id-${url.pathSegments.last}';

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
  Uri get imageUrl => Uri.parse(backingImageUrl);

  @override
  Duration? get duration =>
      backingDuration?.let((seconds) => Duration(seconds: seconds));

  @override
  PodcastId get podcastId => PodcastId(backingPodcastId);
}
