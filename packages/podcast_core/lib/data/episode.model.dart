// Your model definition can live anywhere in lib/**/* as long as it has the .model.dart suffix
// Assume this file is saved at my_app/lib/src/users/user.model.dart

import 'package:podcast_core/services/podcast_audio_handler.dart';

abstract class Episode {
  String get id;

  Uri get url;

  String get title;

  DateTime? get pubDate;

  String? get description;

  Uri get imageUrl;

  Duration? get duration;

  String get podcastId;

  String get safeId => Uri.encodeComponent(id);

  String get safePodcastId => Uri.encodeComponent(podcastId);

  String get localFilePath => '$safeId-${url.pathSegments.last}';

  PodcastMediaItem mediaItem({
    Duration? actualDuration,
    bool? isPlayingFromDownloaded,
  });
}
