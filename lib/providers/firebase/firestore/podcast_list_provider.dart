import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/providers/firebase/firestore/firestore_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'podcast_list_provider.g.dart';

@riverpod
class PodcastPod extends _$PodcastPod {
  late CollectionReference<Map<String, dynamic>> _podcastList;

  @override
  Stream<List<Podcast>> build() async* {
    await ref.watch(firestoreProvider.future);
    final firestore = ref.watch(firestoreProvider.notifier);
    // @TODO: Check if this will continue watching after provider is disposed
    _podcastList = firestore.userCollection('podcastList');
    await for (final snapshot in _podcastList.snapshots()) {
      yield [
        for (final doc in snapshot.docs) Podcast.fromJson(doc.data()),
      ];
    }
  }

  Future<void> addPodcastsToList(Podcast podcast) async {
    if (state.requireValue.any(
      (podcast) => podcast.rssUrl == podcast.rssUrl,
    )) return;

    _podcastList.add(podcast.toJson());
  }
}
