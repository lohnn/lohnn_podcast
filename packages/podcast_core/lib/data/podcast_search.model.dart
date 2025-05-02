import 'package:podcast_core/data/podcast.model.dart';

extension type PodcastSearchId(int id) {
  int get safe => id;
}

abstract class PodcastSearch {
  PodcastSearchId get id;

  PodcastRssUrl get url;

  String get title;

  String get description;

  String get author;

  Uri get artwork;

  String get lastPublished;

  String get language;

  Map<int, String> get categories;
}
