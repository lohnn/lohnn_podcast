import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/extensions/response_extension.dart';

class DateTimeConverter implements JsonConverter<DateTime, Timestamp> {
  const DateTimeConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime dateTime) => Timestamp.fromDate(dateTime);
}

abstract class DocumentReferenceListConverter<T extends ToJson>
    implements JsonConverter<List<DocumentReference<T>>, List<dynamic>> {
  T Function(Map<String, dynamic> json) get fromFirestore;

  const DocumentReferenceListConverter();

  @override
  List<DocumentReference<T>> fromJson(List<dynamic> json) {
    return [
      for (final ref in json.cast<DocumentReference>())
        ref.withConverter(
          fromFirestore: (snapshot, _) => fromFirestore(snapshot.data()!),
          toFirestore: (data, _) => data.toJson(),
        ),
    ];
  }

  @override
  List<DocumentReference<dynamic>> toJson(List<DocumentReference<T>> object) {
    return object;
  }
}

class EpisodeReferenceListConverter
    extends DocumentReferenceListConverter<Episode> {
  const EpisodeReferenceListConverter();

  @override
  Episode Function(Map<String, dynamic> json) get fromFirestore =>
      Episode.fromJson;
}
