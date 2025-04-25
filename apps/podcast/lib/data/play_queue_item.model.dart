import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast/data/episode_impl.model.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/data/play_queue_item.model.dart' as core;

part 'play_queue_item.model.mapper.dart';

@MappableClass()
class PlayQueueItem with PlayQueueItemMappable implements core.PlayQueueItem {
  @override
  final EpisodeImpl episode;
  @override
  final int queueOrder;

  @override
  EpisodeId get episodeId => episode.id;

  String get episodeHiveId => episodeId.toString();

  PlayQueueItem({required this.episode, required this.queueOrder});
}
