abstract class Podcast {
  String get id;

  String get name;

  String get link;

  String get description;

  Uri get imageUrl;

  String? get language;

  String? get lastBuildDate;

  String? get copyright;

  String? get generator;

  String get rssUrl => id;

  Uri get rssUri => Uri.parse(id);

  /// A safe ID that can be used as path and query parameters
  String get safeId => Uri.encodeComponent(id);
}
