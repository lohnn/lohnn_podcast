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
