import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/extensions/map_extensions.dart';
import 'package:podcast/providers/firebase/firestore/firestore_provider.dart';
import 'package:podcast/providers/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'podcast_pod_provider.g.dart';

extension type PodcastId(String id) {}

@riverpod
class PodcastPod extends _$PodcastPod {
  late CollectionReference<Podcast> _podcastList;

  @override
  Stream<Map<PodcastId, Podcast>> build() async* {
    await ref.watch(firestoreProvider.future);
    final firestore = ref.watch(firestoreProvider.notifier);
    // @TODO: Check if this will continue watching after provider is disposed
    _podcastList = firestore.userCollection('podcastList').withConverter(
      fromFirestore: (snapshot, __) {
        return Podcast.fromJson(snapshot.data()!);
      },
      toFirestore: (podcast, __) {
        return podcast.toJson();
      },
    );

    // Some kind of migrating code when changing the data structure
    // await for (final snapshot in _podcastList.snapshots()) {
    //   for (final doc in snapshot.docs) {
    //     final data = doc.data();
    //     try {
    //       Podcast.fromJson(data);
    //     } catch (e) {
    //       migratePodcast(PodcastId(doc.id), data['rssUrl'] as String);
    //     }
    //   }
    // }

    await for (final snapshot in _podcastList.snapshots()) {
      yield {
        for (final doc in snapshot.docs) PodcastId(doc.id): doc.data(),
      };
    }
  }

  Future<void> refreshAll() async {
    await Future.wait([
      for (final (id, podcast) in state.requireValue.records)
        refreshPodcast(id, Uri.parse(podcast.rssUrl)),
    ]);
  }

  Future<void> refreshPodcast(PodcastId id, Uri rssUrl) async {
    final podcast = await ref.read(fetchPodcastProvider(rssUrl).future);
    _podcastList.doc(id.id).set(podcast);
  }

  Future<void> addPodcastsToList(Uri rssUrl) async {
    final podcast = await ref.read(fetchPodcastProvider(rssUrl).future);
    // TODO: Download latest metadata

    switch (state.requireValue.records.firstWhereOrNull(
      (element) => element.$2.rssUrl == rssUrl,
    )) {
      case (final id, final podcast):
        // Update existing
        print('Updating existing!');
        _podcastList.doc(id.id).set(podcast);
      case _:
        // Add new
        print('Adding new podcast!');
        _podcastList.add(podcast);
    }
  }
}
