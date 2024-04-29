import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:podcast/extensions/nullability_extensions.dart';
import 'package:xml/xml.dart';

part 'podcast.freezed.dart';
part 'podcast.g.dart';

@freezed
class Podcast with _$Podcast {
  const factory Podcast({
    required String name,
    required String link,
    required String description,
    required String rssUrl,
    required PodcastImage? image,
    required String? language,
    required String? lastBuildDate,
    required String? copyright,
    required String? generator,
  }) = _Podcast;

  factory Podcast.fromJson(Map<String, dynamic> json) =>
      _$PodcastFromJson(json);

  factory Podcast.fromXml(XmlDocument document, String rssUrl) {
    final channel = document.findAllElements('channel').first;

    // Required fields
    final name = channel.getElementContent('title')!;
    final link = channel.getElementContent('link')!;
    final description = channel.getElementContent('description')!;

    // Optional fields
    final image = channel.getElement('image')?.let(PodcastImage.fromXml);
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
      image: image,
      language: language,
      lastBuildDate: lastBuildDate,
    );
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

extension on XmlElement {
  String? getElementContent(String name) => getElement(name)?.innerText;
}
