import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/extensions/response_extension.dart';
import 'package:podcast/providers/firebase/firestore/episode_list_pod_provider.dart';
import 'package:podcast/providers/firebase/firestore/firestore_provider.dart';
import 'package:podcast/providers/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'podcast_list_pod_provider.g.dart';

@Riverpod(keepAlive: true)
class PodcastListPod extends _$PodcastListPod {
  @override
  Future<CollectionReference<Podcast>> build() async {
    // @TODO: Migrate to let url be id?

    await ref.watch(firestoreProvider.future);
    final firestore = ref.watch(firestoreProvider.notifier);
    // @TODO: Check if this will continue watching after provider is disposed

    refreshAll();
    // @TODO: Maybe automatically check episodes and update here?
    // @TODO: Should we store an episode hash or something to use to check if we need to update maybe?

    return firestore.userCollection('podcastList').withConverter(
      fromFirestore: (snapshot, __) {
        return Podcast.fromJson(snapshot.data()!);
      },
      toFirestore: (podcast, __) {
        return podcast.toJson();
      },
    );
  }

  Future<void> refreshAll() async {
    await future;
    await Future.wait([
      for (final snapshot in (await state.requireValue.get()).docs)
        _refreshPodcast(snapshot),
    ]);
  }

  Future<void> _refreshPodcast(
    QueryDocumentSnapshot<Podcast> storedPodcastSnapshot,
  ) async {
    final storedPodcast = storedPodcastSnapshot.data();

    // Invalidates both podcast and episode fetcher
    ref.invalidate(fetchPodcastProvider(storedPodcast.rssUrl));
    var fetchedPodcast = await ref.read(
      fetchPodcastProvider(storedPodcast.rssUrl).future,
    );

    // region Update episodes list
    // First: fetch/parse all episodes
    final fetchedEpisodes = await ref.read(
      fetchEpisodesProvider(storedPodcast).future,
    );

    final episodeHash = EpisodesHash.fromEpisodes(fetchedEpisodes);
    // check if the new episode hash does not match the stored one
    if (storedPodcast.episodesHash != episodeHash ||
        storedPodcast.totalEpisodes != fetchedEpisodes.length) {
      // If it does NOT match, update the episode list
      await ref.read(
        episodeListPodProvider(storedPodcastSnapshot).future,
      );
    }
    // Update the totalEpisodes with the new value
    // set the episode hash of the "new" [fetchedPodcast] with the hash from the new list
    fetchedPodcast = fetchedPodcast.copyWith(
      episodesHash: episodeHash,
      totalEpisodes: fetchedEpisodes.length,
    );
    // endregion Update episodes list

    // If the data we downloaded from the RSS feed is identical,
    // no need to update
    if (storedPodcast != fetchedPodcast) {
      state.requireValue.doc(storedPodcastSnapshot.id).set(fetchedPodcast);
    }
  }

  Future<void> addPodcastsToList(String rssUrl) async {
    // final downloadedPodcast =
    //     await ref.read(fetchPodcastProvider(rssUrl).future);

    throw UnimplementedError();
    // switch (state.requireValue.firstWhereOrNull(
    //   (element) => element.podcast.rssUrl == rssUrl,
    // )) {
    //   case PodcastListRow(:final id, :final podcast):
    //     if (podcast != downloadedPodcast) {
    //       // Update existing
    //       debugPrint('Updating existing!');
    //       _podcastList.doc(id.id).set(podcast);
    //     }
    //   case _:
    //     // Add new
    //     debugPrint('Adding new podcast!');
    //     _podcastList.add(downloadedPodcast);
    // }
  }

  Future<CollectionReference<Map<String, dynamic>>>
      collectionForPodcast<T extends ToJson>(
    String collectionPath,
    PodcastId podcast,
  ) async {
    await future;
    return state.requireValue.doc(podcast.id).collection(collectionPath);
  }
}
