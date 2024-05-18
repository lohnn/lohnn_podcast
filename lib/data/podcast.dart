import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hashlib/hashlib.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/data/firebase_converters/date_time_converter.dart';
import 'package:podcast/extensions/nullability_extensions.dart';
import 'package:podcast/extensions/xml_element_extension.dart';
import 'package:xml/xml.dart';

part 'podcast.freezed.dart';
part 'podcast.g.dart';

extension type const PodcastId._(String id) {
  factory PodcastId(QueryDocumentSnapshot<Podcast> snapshot) {
    return PodcastId._(snapshot.id);
  }

  factory PodcastId.fromString(String id) = PodcastId._;
}

extension type const EpisodeHash._(String hash) {
  factory EpisodeHash.fromEpisode(Episode episode) {
    return EpisodeHash._(md5.string(episode.toString()).toString());
  }

  factory EpisodeHash.fromJson(String hash) => EpisodeHash._(hash);

  String toJson() => hash;
}

extension type const EpisodesHash._(String hash) {
  factory EpisodesHash.fromEpisodes(Iterable<Episode> episodes) {
    final sink = md5.createSink();
    for (final episode in episodes) {
      sink.add(episode.toString().codeUnits);
    }
    sink.close();
    return EpisodesHash._(sink.digest().toString());
  }

  factory EpisodesHash.fromJson(String hash) => EpisodesHash._(hash);

  String toJson() => hash;
}

@freezed
class Podcast with _$Podcast {
  const factory Podcast({
    required String name,
    required String link,
    required String description,
    required String rssUrl,
    required Uri image,
    required String? language,
    required String? lastBuildDate,
    required String? copyright,
    required String? generator,
    // Below is fields used for state
    required bool showDot,
    required EpisodesHash? episodesHash,
    @Default({})
    @EpisodeReferenceMapConverter()
    Map<DocumentReference<Episode>, EpisodeHash> allEpisodes,
    @Default({})
    @EpisodeReferenceSetConverter()
    Set<DocumentReference<Episode>> listenedEpisodes,
    @Default({})
    @EpisodeReferenceSetConverter()
    Set<DocumentReference<Episode>> deletedEpisodes,
  }) = _Podcast;

  const Podcast._();

  factory Podcast.fromJson(Map<String, dynamic> json) =>
      _$PodcastFromJson(json);

  factory Podcast.fromXml(XmlDocument document, String rssUrl) {
    final channel = document.findAllElements('channel').first;

    // Required fields
    final name = channel.getElementContent('title')!;
    final link = channel.getElementContent('link')!;
    final description = channel.getElementContent('description')!;
    final image = channel.getElement('image')?.let(PodcastImage.fromXml).url ??
        channel.getElement('itunes:image')!.getAttribute('href')!;

    // Optional fields
    final language = channel.getElementContent('language');
    final lastBuildDate = channel.getElementContent('lastBuildDate');
    final copyright = channel.getElementContent('copyright');
    final generator = channel.getElementContent('generator');

    return Podcast(
      name: name,
      link: link,
      description: description,
      rssUrl: rssUrl,
      copyright: copyright,
      generator: generator,
      image: image.let(Uri.parse),
      language: language,
      lastBuildDate: lastBuildDate,
      showDot: false,
      episodesHash: null,
    );
  }

  int get totalEpisodes => allEpisodes.length;

  factory Podcast.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? _,
  ) {
    return Podcast.fromJson(snapshot.data()!);
  }

  static Map<String, Object?> toFirestore(
    Podcast value,
    SetOptions? _,
  ) {
    return value.toJson();
  }
}

@freezed
class PodcastImage with _$PodcastImage {
  const factory PodcastImage({
    required String url,
    required String title,
    required String link,
  }) = _PodcastImage;

  factory PodcastImage.fromJson(Map<String, dynamic> json) =>
      _$PodcastImageFromJson(json);

  factory PodcastImage.fromXml(XmlElement element) {
    final url = element.getElementContent('url')!;
    final title = element.getElementContent('title')!;
    final link = element.getElementContent('link')!;

    return PodcastImage(url: url, title: title, link: link);
  }
}
