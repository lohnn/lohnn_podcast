extension type PodcastId(String id) {
  String get safe => Uri.encodeComponent(id);

  factory PodcastId.fromPathParameter(String pathParameter) {
    return PodcastId(Uri.decodeComponent(pathParameter));
  }
}

extension type PodcastRssUrl(Uri url) {
  factory PodcastRssUrl.parse(String url) {
    return PodcastRssUrl(Uri.parse(url));
  }
}

abstract class Podcast {
  /// The unique identifier for the podcast.
  PodcastId get id;

  /// The RSS feed URL of the podcast.
  PodcastRssUrl get url;

  /// The URL of the podcast's website.
  Uri get link;

  /// The title of the podcast.
  String get title;

  /// The description of the podcast.
  String get description;

  /// The URL of the podcast's artwork.
  Uri get artwork;

  /// The date when the podcast was last published.
  String? get lastPublished;

  /// The language of the podcast.
  String? get language;

  /// The categories associated with the podcast.
  Map<int, String> get categories;
}
