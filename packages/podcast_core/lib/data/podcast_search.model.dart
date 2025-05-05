import 'package:podcast_core/data/podcast.model.dart';

extension type PodcastSearchId(int id) implements Object {}

abstract class PodcastSearch {
  PodcastSearchId get id;

  PodcastRssUrl get url;

  String get title;

  String get description;

  String get author;

  Uri get artwork;

  DateTime get lastPublished;

  String get language;

  Map<int, String> get categories;
}
