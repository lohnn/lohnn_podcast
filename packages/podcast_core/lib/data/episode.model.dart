// Your model definition can live anywhere in lib/**/* as long as it has the .model.dart suffix
// Assume this file is saved at my_app/lib/src/users/user.model.dart

import 'package:podcast_core/data/podcast.model.dart';
import 'package:podcast_core/services/podcast_audio_handler.dart';

extension type EpisodeId(int id) {}

abstract class Episode {
  EpisodeId get id;

  Uri get url;

  String get title;

  DateTime? get pubDate;

  String? get description;

  Uri get imageUrl;

  Duration? get duration;

  PodcastId get podcastId;

  String get localFilePath => '$id-${url.pathSegments.last}';

  PodcastMediaItem mediaItem({
    Duration? actualDuration,
    bool? isPlayingFromDownloaded,
  });
}
