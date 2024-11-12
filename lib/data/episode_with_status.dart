import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast/data/episode.model.dart';
import 'package:podcast/data/user_episode_status.model.dart';
import 'package:podcast/services/podcast_audio_handler.dart';

part 'episode_with_status.mapper.dart';

@MappableClass()
class EpisodeWithStatus with EpisodeWithStatusMappable {
  final Episode episode;
  final UserEpisodeStatus? status;

  EpisodeWithStatus({
    required this.episode,
    this.status,
  });

  PodcastMediaItem mediaItem({
    Duration? actualDuration,
  }) =>
      PodcastMediaItem(
        episode: this,
        id: episode.url.uri.toString(),
        title: episode.title,
        artUri: episode.imageUrl.uri,
        duration: actualDuration ?? episode.duration?.duration,
      );
}
