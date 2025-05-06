import 'package:podcast_core/data/episode.model.dart';

abstract class PlayQueueItem {
  Episode get episode;

  int get queueOrder;

  EpisodeId get episodeId => episode.id;
}
