import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast/data/podcast_impl.model.dart';
import 'package:podcast_common/podcast_common.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/data/podcast.model.dart';
import 'package:podcast_core/extensions/nullability_extensions.dart';
import 'package:podcast_core/services/podcast_audio_handler.dart';

part 'episode_impl.model.mapper.dart';

@MappableClass()
class EpisodeImpl with EpisodeImplMappable implements Episode {
  final String backingId;
  final String backingUrl;
  @override
  final String title;
  final int datePublished;
  @override
  final String? description;
  final String backingImageUrl;
  final int? backingDuration;
  final String backingPodcastId;

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

  factory EpisodeImpl.fromRssEpisode({
    required RssEpisode rssEpisode,
    required PodcastImpl podcast,
  }) {
    return EpisodeImpl(
      backingId: Uri.encodeComponent(rssEpisode.guid),
      backingUrl: rssEpisode.url.toString(),
      title: rssEpisode.title,
      datePublished: rssEpisode.pubDate.millisecondsSinceEpoch ~/ 1000,
      description: rssEpisode.description,
      backingImageUrl:
          rssEpisode.imageUrl?.toString() ?? podcast.artwork.toString(),
      backingDuration: rssEpisode.duration?.inSeconds,
      backingPodcastId: podcast.backingId,
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
