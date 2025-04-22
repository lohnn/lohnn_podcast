abstract class UserEpisodeStatus {
  final String episodeId;
  final bool isPlayed;
  final Duration currentPosition;

  UserEpisodeStatus({
    required this.episodeId,
    required this.isPlayed,
    required this.currentPosition,
  });
}
