import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast_core/data/episode_user_status.model.dart' as core;

part 'episode_user_status.model.mapper.dart';

@MappableClass()
class EpisodeUserStatus
    with EpisodeUserStatusMappable
    implements core.EpisodeUserStatus {
  @override
  final String userId;
  @override
  final String episodeId;
  @override
  final bool listened;
  @override
  final Duration currentPosition;

  EpisodeUserStatus({
    required this.userId,
    required this.episodeId,
    required this.listened,
    required this.currentPosition,
  });
}
