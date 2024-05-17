import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/data/firebase_converters/date_time_converter.dart';

part 'podcast_user.freezed.dart';
part 'podcast_user.g.dart';

@freezed
class PodcastUser with _$PodcastUser {
  const factory PodcastUser({
    @Default([])
    @EpisodeReferenceListConverter()
    List<DocumentReference<Episode>> playQueue,
  }) = _PodcastUser;

  const PodcastUser._();

  factory PodcastUser.fromJson(Map<String, dynamic> json) =>
      _$PodcastUserFromJson(json);
}
