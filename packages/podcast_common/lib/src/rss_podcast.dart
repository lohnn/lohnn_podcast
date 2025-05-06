import 'package:podcast_common/src/extensions/nullability_extensions.dart';
import 'package:podcast_common/src/extensions/xml_element_extension.dart';
import 'package:podcast_common/src/rss_episode.dart';
import 'package:xml/xml.dart';

class RssPodcast {
  final String title;
  final String description;
  final Uri link;
  final Uri artwork;
  final Set<String> categories;
  final String? language;
  final String? lastPublished;
  final String? copyright;
  final String? generator;
  final List<RssEpisode> episodes;

  RssPodcast({
    required this.title,
    required this.description,
    required this.link,
    required this.artwork,
    required this.episodes,
    required this.categories,
    required this.language,
    required this.lastPublished,
    required this.copyright,
    required this.generator,
  });

  factory RssPodcast.fromXmlString(String document, Uri rssUri) {
    final xmlDocument = XmlDocument.parse(document);
    return RssPodcast.fromXml(xmlDocument, rssUri);
  }

  factory RssPodcast.fromXml(XmlDocument document, Uri rssUri) {
    final channel = document.findAllElements('channel').first;

    // Required fields
    final name = channel.getElementContent('title')!;
    final link =
        channel.getElement('link')?.getAttribute('href') ??
        channel.getElementContent('link') ??
        channel.getElement('atom:link')?.getAttribute('href');
    final description = channel.getElementContent('description')!;
    final image =
        channel.getElement('image')?.getElementContent('url') ??
        channel.getElement('itunes:image')!.getAttribute('href')!;

    final categories =
        channel
            .findAllElements('itunes:category')
            .map((e) => e.getAttribute('text'))
            .nonNulls
            .toSet();

    // Optional fields
    final language = channel.getElementContent('language');
    final lastBuildDate = channel.getElementContent('lastBuildDate');
    final copyright = channel.getElementContent('copyright');
    final generator = channel.getElementContent('generator');

    // Episodes
    final episodes = channel
        .findAllElements('item')
        .map(RssEpisode.fromXml)
        .toList(growable: false);

    return RssPodcast(
      title: name,
      description: description,
      link: link?.let(Uri.parse) ?? rssUri,
      artwork: Uri.parse(image),
      categories: categories,
      copyright: copyright,
      generator: generator,
      lastPublished: lastBuildDate,
      language: language,
      episodes: episodes,
    );
  }
}
