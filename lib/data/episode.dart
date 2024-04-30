import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:podcast/extensions/response_extension.dart';
import 'package:podcast/extensions/xml_element_extension.dart';
import 'package:xml/xml.dart';

part 'episode.freezed.dart';
part 'episode.g.dart';

@freezed
class Episode with _$Episode implements ToJson {
  const factory Episode({
    required String guid,
    required String url,
    required String title,
    required DateTime pubDate,
    required String? description,
    required String? imageUrl,
    @Default(false) bool listened,
  }) = _Episode;

  const Episode._();

  factory Episode.fromJson(Map<String, dynamic> json) =>
      _$EpisodeFromJson(json);

  /// Adds the fields from [other] that are set at runtime, such as [listened].
  Episode operator +(Episode other) => copyWith(listened: other.listened);

  static final _rfc822Format = DateFormat('EEE, dd MMM yyyy HH:mm:ss');

  static Iterable<Episode> fromXml(XmlDocument document) sync* {
    for (final item in document.findAllElements('item')) {
      // Required fields??
      final guid = item.getElementContent('guid')!.replaceAll('/', '-');
      if (guid.contains('/')) {
        throw UnsupportedError(item.toString());
      }

      final pubDateValue = item.getElementContent('pubDate')!;
      final pubDate =
          _rfc822Format.tryParse(pubDateValue) ?? DateTime.parse(pubDateValue);

      final link = item.getElementContent('link') ??
          item.getElement('enclosure')?.getAttribute('url');
      if (link == null) {
        debugPrint('Link null for: $item');
      }
      final title = item.getElementContent('title') ??
          item.getElementContent('itunes:title');
      if (title == null) {
        debugPrint('Title null for: $item');
      }

      // Optional fields
      final imageUrl = item.getElement('itunes:image')?.getAttribute('href');
      final description = item.getElementContent('description');

      yield Episode(
        guid: guid,
        url: link!,
        title: title!,
        pubDate: pubDate,
        description: description,
        imageUrl: imageUrl,
      );
    }
  }
}
