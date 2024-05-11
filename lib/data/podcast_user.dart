import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:podcast/data/episode.dart';

part 'podcast_user.freezed.dart';

@freezed
class PodcastUser with _$PodcastUser {
  const factory PodcastUser({
    @Default([]) List<DocumentReference<Episode>> playQueue,
  }) = _PodcastUser;

  const PodcastUser._();

  factory PodcastUser.fromFirestore(Map<String, dynamic> json) {
    return PodcastUser(
      playQueue: [
        for (final episodeSnapshot
            in (json['playQueue'] as List<dynamic>).cast<DocumentReference>())
          episodeSnapshot.withConverter(
            fromFirestore: (snapshot, _) => Episode.fromJson(snapshot.data()!),
            toFirestore: (data, _) => data.toJson(),
          ),
      ],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'playQueue': playQueue,
    };
  }
}
