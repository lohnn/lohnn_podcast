import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/data/user_episode_status.model.dart';

class TestUserEpisodeStatus extends UserEpisodeStatus {
  TestUserEpisodeStatus({
    required EpisodeId episodeId,
    required bool isPlayed,
    required Duration currentPosition,
  }) : super(
          episodeId: episodeId,
          isPlayed: isPlayed,
          currentPosition: currentPosition,
        );
}
