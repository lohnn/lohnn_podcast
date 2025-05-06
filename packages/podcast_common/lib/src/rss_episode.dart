import 'package:intl/intl.dart';
import 'package:podcast_common/src/extensions/nullability_extensions.dart';
import 'package:podcast_common/src/extensions/xml_element_extension.dart';
import 'package:xml/xml.dart';

class RssEpisode {
  final String guid;
  final Uri url;
  final String title;
  final DateTime pubDate;
  final String? description;
  final Uri? imageUrl;
  final Duration? duration;

  const RssEpisode({
    required this.guid,
    required this.url,
    required this.title,
    required this.pubDate,
    required this.description,
    required this.imageUrl,
    required this.duration,
  });

  static final _rfc822Format = DateFormat('EEE, dd MMM yyyy HH:mm:ss');

  factory RssEpisode.fromXml(XmlElement element) {
    // region Required fields
    final guidElement = element.getElement('guid')!;

    final guid = guidElement.getAttribute('text') ?? guidElement.innerText;

    final pubDateValue = element.getElementContent('pubDate')!;
    final pubDate =
        _rfc822Format.tryParse(pubDateValue) ?? DateTime.parse(pubDateValue);

    final link = Uri.parse(
      element.getElement('enclosure')!.getAttribute('url')!,
    );
    final title =
        element.getElementContent('title') ??
        element.getElementContent('itunes:title')!;

    final durationString = element.getElementContent('itunes:duration');
    final duration = switch (durationString
        ?.split(':')
        .map(int.parse)
        .toList()) {
      null => null,
      [final hours, final minutes, final seconds] => Duration(
        hours: hours,
        minutes: minutes,
        seconds: seconds,
      ),
      [final minutes, final seconds] => Duration(
        minutes: minutes,
        seconds: seconds,
      ),
      [final seconds] => Duration(seconds: seconds),
      _ => null,
    };
    // endregion Required fields

    // region Optional fields
    final imageUrl = element.getElement('itunes:image')?.getAttribute('href');
    final description = element.getElementContent('description');
    // endregion Required fields

    return RssEpisode(
      guid: guid,
      url: link,
      title: title,
      duration: duration,
      pubDate: pubDate,
      description: description,
      imageUrl: imageUrl?.let(Uri.parse),
    );
  }
}
