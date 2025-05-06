import 'package:podcast_core/data/episode.model.dart';

abstract class UserEpisodeStatus {
  final EpisodeId episodeId;
  final bool isPlayed;
  final Duration currentPosition;

  UserEpisodeStatus({
    required this.episodeId,
    required this.isPlayed,
    required this.currentPosition,
  });
}
