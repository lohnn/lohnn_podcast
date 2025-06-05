import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/data/podcast.model.dart';
import 'package:podcast_core/services/podcast_audio_handler.dart';

export 'package:podcast_core/data/episode.model.dart';

class TestEpisode implements Episode {
  @override
  final EpisodeId id;
  @override
  final Uri url;
  @override
  final String title;
  @override
  final DateTime? pubDate;
  @override
  final String? description;
  @override
  final Uri imageUrl;
  @override
  final Duration? duration;
  @override
  final PodcastId podcastId;

  TestEpisode({
    required this.id,
    required this.url,
    required this.title,
    this.pubDate,
    this.description,
    required this.imageUrl,
    this.duration,
    required this.podcastId,
  });

  @override
  String get localFilePath => '$id-${url.pathSegments.last}';

  @override
  PodcastMediaItem mediaItem({Duration? actualDuration, bool? isPlayingFromDownloaded}) {
    return PodcastMediaItem(
      episode: this,
      id: id.safe,
      title: title,
      artUri: imageUrl,
      duration: actualDuration ?? duration,
    );
  }
}
