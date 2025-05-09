import 'package:dart_mappable/dart_mappable.dart';
import 'package:podcast_common/podcast_common.dart';
import 'package:podcast_core/data/podcast.model.dart';

part 'podcast_impl.model.mapper.dart';

@MappableClass()
class PodcastImpl with PodcastImplMappable implements Podcast {
  final String backingId;
  final String backingUrl;
  @override
  final String title;
  @override
  final String description;
  final String backingArtwork;
  @override
  final String? language;
  @override
  final Set<String> categories;
  @override
  DateTime lastPublished;

  @override
  PodcastRssUrl get url => PodcastRssUrl.parse(backingUrl);

  @override
  Uri get artwork => Uri.parse(backingArtwork);

  PodcastImpl({
    required this.backingId,
    required this.backingUrl,
    required this.title,
    required this.description,
    required this.backingArtwork,
    required this.lastPublished,
    required this.language,
    this.categories = const {},
  });

  factory PodcastImpl.fromRssPodcast(RssPodcast rssPodcast) {
    return PodcastImpl(
      backingId: rssPodcast.link.toString(),
      backingUrl: rssPodcast.link.toString(),
      title: rssPodcast.title,
      description: rssPodcast.description,
      backingArtwork: rssPodcast.artwork.toString(),
      lastPublished: rssPodcast.lastPublished ?? DateTime.now(),
      language: rssPodcast.language,
      categories: rssPodcast.categories,
    );
  }

  @override
  PodcastId get id => PodcastId(backingId);

  @override
  Uri get link => Uri.parse(backingUrl);
}
