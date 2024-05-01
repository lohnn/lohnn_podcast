import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/extensions/response_extension.dart';
import 'package:podcast/providers/firebase/firestore/firestore_provider.dart';
import 'package:podcast/providers/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'podcast_list_pod_provider.freezed.dart';
part 'podcast_list_pod_provider.g.dart';

extension type PodcastId(String id) {}

@freezed
class PodcastListRow with _$PodcastListRow {
  const factory PodcastListRow({
    required PodcastId id,
    required Podcast podcast,
    required int totalEpisodes,
    required int unlistenedEpisodes,
    required bool hasNew,
  }) = _PodcastListRow;
}

@Riverpod(keepAlive: true)
class PodcastListPod extends _$PodcastListPod {
  late CollectionReference<Podcast> _podcastList;

  @override
  Stream<List<PodcastListRow>> build() async* {
    // @TODO: Migrate to let url be id?

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

    await for (final snapshot in _podcastList.orderBy('name').snapshots()) {
      yield [
        for (final doc in snapshot.docs)
          PodcastListRow(
            id: PodcastId(doc.id),
            podcast: doc.data(),
            hasNew: true,
            totalEpisodes: (await _podcastList
                        .doc(doc.id)
                        .collection('episodes')
                        .count()
                        .get())
                    .count ??
                0,
            unlistenedEpisodes: (await _podcastList
                        .doc(doc.id)
                        .collection('episodes')
                        .where('listened', isEqualTo: true)
                        .count()
                        .get())
                    .count ??
                0,
          ),
      ];
    }
  }

  Future<void> refreshAll() async {
    await Future.wait([
      for (final PodcastListRow(:id, :podcast) in state.requireValue)
        _refreshPodcast(id, podcast.rssUrl),
    ]);
  }

  Future<void> _refreshPodcast(PodcastId id, String rssUrl) async {
    ref.invalidate(fetchPodcastProvider(rssUrl));
    final podcast = await ref.read(fetchPodcastProvider(rssUrl).future);
    _podcastList.doc(id.id).set(podcast);
  }

  Future<void> addPodcastsToList(String rssUrl) async {
    final downloadedPodcast =
        await ref.read(fetchPodcastProvider(rssUrl).future);

    switch (state.requireValue.firstWhereOrNull(
      (element) => element.podcast.rssUrl == rssUrl,
    )) {
      case PodcastListRow(:final id, :final podcast):
        if (podcast != downloadedPodcast) {
          // Update existing
          debugPrint('Updating existing!');
          _podcastList.doc(id.id).set(podcast);
        }
      case _:
        // Add new
        debugPrint('Adding new podcast!');
        _podcastList.add(downloadedPodcast);
    }
  }

  CollectionReference<Map<String, dynamic>>
      collectionForPodcast<T extends ToJson>(
    String collectionPath,
    Podcast podcast,
  ) {
    final id = state.requireValue
        .firstWhere((element) => element.podcast == podcast)
        .id;

    return _podcastList.doc(id.id).collection(collectionPath);
  }
}
