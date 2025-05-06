import 'package:flutter/foundation.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/data/user_episode_status.model.dart';

@immutable
class EpisodeWithStatus {
  final Episode episode;
  final UserEpisodeStatus? status;

  const EpisodeWithStatus({required this.episode, required this.status});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EpisodeWithStatus &&
          runtimeType == other.runtimeType &&
          episode == other.episode &&
          status == other.status;

  @override
  int get hashCode => Object.hash(episode, status);

  bool get isPlayed => status?.isPlayed ?? false;
}
