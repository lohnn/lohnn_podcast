import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast/data/episode.model.dart';
import 'package:podcast/data/serdes/duration_model.dart';
import 'package:podcast/data/user_episode_status.model.dart';

part 'episode_with_status.mapper.dart';

@MappableClass()
class EpisodeWithStatus with EpisodeWithStatusMappable {
  final Episode episode;
  final bool playingFromDownloaded;
  final UserEpisodeStatus status;

  factory EpisodeWithStatus({
    required Episode episode,
    required bool playingFromDownloaded,
    UserEpisodeStatus? status,
  }) {
    return EpisodeWithStatus._(
      episode: episode,
      playingFromDownloaded: playingFromDownloaded,
      status:
          status ??
          UserEpisodeStatus(
            episodeId: episode.id,
            isPlayed: false,
            currentPosition: DurationModel(Duration.zero),
          ),
    );
  }

  EpisodeWithStatus._({
    required this.episode,
    required this.playingFromDownloaded,
    required this.status,
  });
}
