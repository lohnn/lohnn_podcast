import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/extensions/map_extensions.dart';
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

abstract class DocumentReferenceSetConverter<T extends ToJson>
    implements JsonConverter<Set<DocumentReference<T>>, List<dynamic>> {
  T Function(Map<String, dynamic> json) get fromFirestore;

  const DocumentReferenceSetConverter();

  @override
  Set<DocumentReference<T>> fromJson(List<dynamic> json) {
    return {
      for (final ref in json.cast<DocumentReference>())
        ref.withConverter(
          fromFirestore: (snapshot, _) => fromFirestore(snapshot.data()!),
          toFirestore: (data, _) => data.toJson(),
        ),
    };
  }

  @override
  List<DocumentReference<dynamic>> toJson(Set<DocumentReference<T>> object) {
    return object.toList();
  }
}

class EpisodeReferenceSetConverter
    extends DocumentReferenceSetConverter<Episode> {
  const EpisodeReferenceSetConverter();

  @override
  Episode Function(Map<String, dynamic> json) get fromFirestore =>
      Episode.fromJson;
}

class EpisodeReferenceMapConverter
    implements
        JsonConverter<Map<DocumentReference<Episode>, EpisodeHash>,
            Map<String, dynamic>> {
  const EpisodeReferenceMapConverter();

  @override
  Map<DocumentReference<Episode>, EpisodeHash> fromJson(
    Map<String, dynamic> json,
  ) {
    final firestore = FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      databaseId: 'podcast',
    );
    return {
      for (final (refPath, hash) in json.cast<String, String>().records)
        firestore.doc(refPath).withConverter(
              fromFirestore: (snapshot, _) =>
                  Episode.fromJson(snapshot.data()!),
              toFirestore: (data, _) => data.toJson(),
            ): EpisodeHash.fromJson(hash),
    };
  }

  @override
  Map<String, dynamic> toJson(
    Map<DocumentReference<Episode>, EpisodeHash> object,
  ) {
    return {
      for (final (ref, hash) in object.records) ref.path: hash,
    };
  }
}
