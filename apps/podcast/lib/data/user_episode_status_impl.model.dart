import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/data/user_episode_status.model.dart';

part 'user_episode_status_impl.model.mapper.dart';

@MappableClass()
class UserEpisodeStatusImpl
    with UserEpisodeStatusImplMappable
    implements UserEpisodeStatus {
  final int backingEpisodeId;
  @override
  final bool isPlayed;
  @override
  final Duration currentPosition;

  UserEpisodeStatusImpl({
    required this.backingEpisodeId,
    required this.isPlayed,
    required this.currentPosition,
  });

  UserEpisodeStatusImpl.usingEpisodeId({
    required EpisodeId episodeId,
    required this.isPlayed,
    required this.currentPosition,
  }) : backingEpisodeId = episodeId.id;

  @override
  EpisodeId get episodeId => EpisodeId(backingEpisodeId);

  String get episodeHiveId => episodeId.toString();
}
