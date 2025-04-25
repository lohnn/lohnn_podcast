import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast_core/data/podcast.model.dart' as core;
import 'package:podcast_core/data/podcast.model.dart' show PodcastId;
import 'package:podcast_core/extensions/nullability_extensions.dart';

export 'package:podcast_core/data/podcast.model.dart' show PodcastId;

part 'podcast_impl.model.mapper.dart';

@MappableClass()
class PodcastImpl with PodcastImplMappable implements core.Podcast {
  @MappableField(key: 'id')
  final int backingId;
  @MappableField(key: 'url')
  final String backingUrl;
  @override
  final String title;
  @override
  final String description;
  @override
  final String author;
  @MappableField(key: 'artwork')
  final String backingArtwork;
  @override
  final String language;
  @override
  final Map<int, String> categories;
  @MappableField(key: 'newestItemPublishTime')
  final int? newestItemPublishTime;
  @MappableField(key: 'lastUpdateTime')
  final int? lastUpdateTime;

  @override
  String get lastPublished => lastPublishedDateTime.toString();

  DateTime get lastPublishedDateTime =>
      (lastUpdateTime ?? newestItemPublishTime)!.let(
        DateTime.fromMicrosecondsSinceEpoch,
      );

  @override
  Uri get url => Uri.parse(backingUrl);

  @override
  Uri get artwork => Uri.parse(backingArtwork);

  String get hiveId => id.toString();

  PodcastImpl({
    required this.backingId,
    required this.backingUrl,
    required this.title,
    required this.description,
    required this.backingArtwork,
    required this.author,
    required this.newestItemPublishTime,
    required this.lastUpdateTime,
    required this.language,
    this.categories = const {},
  });

  @override
  PodcastId get id => PodcastId(backingId);
}
