import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:podcast/data/episode.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'episode_listener_pod_provider.g.dart';

@riverpod
class EpisodeListenerPod extends _$EpisodeListenerPod {
  @override
  FutureOr<void> build(
    QueryDocumentSnapshot<Episode> podcastSnapshot,
  ) async {

  }
}
