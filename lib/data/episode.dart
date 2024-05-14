import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';
import 'package:podcast/data/firebase_converters/date_time_converter.dart';
import 'package:podcast/data/firebase_converters/duration_converter.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/extensions/nullability_extensions.dart';
import 'package:podcast/extensions/response_extension.dart';
import 'package:podcast/extensions/xml_element_extension.dart';
import 'package:podcast/services/podcast_audio_handler.dart';
import 'package:xml/xml.dart';

part 'episode.freezed.dart';
part 'episode.g.dart';

@freezed
class Episode with _$Episode implements ToJson {
  const factory Episode({
    required String guid,
    required Uri url,
    required String title,
    @DateTimeConverter() required DateTime? pubDate,
    required String? description,
    required Uri imageUrl,
    @DurationConverter() required Duration? duration,
    // region Dynamic fields
    @Default(false) bool listened,
    @DurationConverter() Duration? currentPosition,
    // endregion Dynamic fields
  }) = _Episode;

  const Episode._();

  factory Episode.fromJson(Map<String, dynamic> json) =>
      _$EpisodeFromJson(json);

  PodcastMediaItem mediaItem(DocumentSnapshot<Episode> episodeSnapshot) =>
      PodcastMediaItem(
        episode: episodeSnapshot,
        id: url.toString(),
        title: title,
        artUri: imageUrl,
        duration: duration,
      );

  /// Adds the fields from [other] that are set at runtime, such as [listened]
  /// and [currentPosition].
  Episode operator +(Episode other) => copyWith(
        listened: other.listened,
        currentPosition: other.currentPosition,
      );

  static final _rfc822Format = DateFormat('EEE, dd MMM yyyy HH:mm:ss');

  static Iterable<Episode> fromXml(
    XmlDocument document, {
    required Podcast podcast,
  }) sync* {
    for (final item in document.findAllElements('item')) {
      // region Required fields
      final guid = Uri.encodeComponent(item.getElementContent('guid')!);
      if (guid.contains('/')) {
        throw UnsupportedError(item.toString());
      }

      final pubDateValue = item.getElementContent('pubDate')!;
      final pubDate =
          _rfc822Format.tryParse(pubDateValue) ?? DateTime.parse(pubDateValue);

      final link = item.getElement('enclosure')?.getAttribute('url');
      if (link == null) {
        debugPrint('Link null for: $item');
      }
      final title = item.getElementContent('title') ??
          item.getElementContent('itunes:title');
      if (title == null) {
        debugPrint('Title null for: $item');
      }
      final durationString = item.getElementContent('itunes:duration');
      final duration =
          switch (durationString?.split(':').map(int.parse).toList()) {
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
      final imageUrl = item.getElement('itunes:image')?.getAttribute('href');
      final description = item.getElementContent('description');
      // endregion Required fields

      yield Episode(
        guid: guid,
        url: Uri.parse(link!),
        title: title!,
        duration: duration,
        pubDate: pubDate,
        description: description,
        imageUrl: imageUrl?.let(Uri.parse) ?? podcast.image,
      );
    }
  }
}
