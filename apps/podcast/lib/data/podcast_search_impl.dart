import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast_core/data/podcast.model.dart';
import 'package:podcast_core/data/podcast_search.model.dart';

part 'podcast_search_impl.mapper.dart';

@MappableClass()
class PodcastSearchImpl
    with PodcastSearchImplMappable
    implements PodcastSearch {
  @override
  final PodcastSearchId id;

  @override
  final Uri artwork;

  @override
  final PodcastRssUrl url;

  @override
  final String author;

  @override
  final Map<int, String> categories;

  @override
  final String description;

  @override
  final String language;

  final DateTime? newestItemPublishTime;
  final DateTime? lastUpdateTime;

  @override
  DateTime get lastPublished => newestItemPublishTime ?? lastUpdateTime!;

  @override
  final String title;

  PodcastSearchImpl({
    required this.artwork,
    required this.author,
    this.categories = const {},
    required this.description,
    required this.id,
    required this.language,
    this.lastUpdateTime,
    this.newestItemPublishTime,
    required this.title,
    required this.url,
  });
}
