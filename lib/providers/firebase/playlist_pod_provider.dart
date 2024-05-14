import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/providers/firebase/firestore/podcast_user_pod_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playlist_pod_provider.g.dart';

@riverpod
class PlaylistPod extends _$PlaylistPod {
  @override
  Future<List<DocumentSnapshot<Episode>>> build() async {
    return [
      for (final reference in await ref.watch(
        podcastUserPodProvider.selectAsync((data) => data.playQueue),
      ))
        await reference.get(),
    ];
  }
}
