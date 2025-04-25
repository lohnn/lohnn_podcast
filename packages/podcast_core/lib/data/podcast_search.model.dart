extension type PodcastId(int id) {}

abstract class PodcastSearch {
  PodcastId get id;

  Uri get url;

  String get title;

  String get description;

  String get author;

  Uri get artwork;

  String get lastPublished;

  String get language;

  Map<int, String> get categories;
}
