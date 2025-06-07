import 'package:flutter/cupertino.dart';
import 'package:podcast_core/data/podcast.model.dart';

export 'package:podcast_core/data/podcast.model.dart';

class TestPodcast implements Podcast {
  @override
  final PodcastId id;
  @override
  final PodcastRssUrl url;
  @override
  final Uri link;
  @override
  final String title;
  @override
  final String description;
  @override
  final Uri artwork;
  @override
  final DateTime? lastPublished;
  @override
  final String? language;
  @override
  final Set<String> categories;

  @visibleForTesting
  factory TestPodcast.mocked({
    String id = '1',
    String url = 'http://example.com/feed.xml',
    String link = 'http://example.com',
    String title = 'Test Podcast Title',
    String description = 'Test Podcast Description',
    String artwork = 'http://example.com/podcast_image.png',
    DateTime? lastPublished,
    String? language,
    Set<String> categories = const {},
  }) => TestPodcast(
    id: PodcastId(id),
    url: PodcastRssUrl.parse(url),
    link: Uri.parse(link),
    title: title,
    description: description,
    artwork: Uri.parse(artwork),
    lastPublished: lastPublished,
  );

  TestPodcast({
    required this.id,
    required this.url,
    required this.link,
    required this.title,
    required this.description,
    required this.artwork,
    this.lastPublished,
    this.language,
    this.categories = const {},
  });
}
