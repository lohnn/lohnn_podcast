import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:integral_isolates/integral_isolates.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/extensions/map_extensions.dart';
import 'package:podcast/extensions/response_extension.dart';
import 'package:podcast/providers/firebase/firestore/episode_list_pod_provider.dart';
import 'package:podcast/providers/firebase/firestore/podcast_user_pod_provider.dart';
import 'package:podcast/providers/isolate_provider.dart';
import 'package:podcast/providers/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'podcast_list_pod_provider.g.dart';

@riverpod
Future<DocumentSnapshot<Podcast>> podcast(
  PodcastRef ref,
  PodcastId id,
) async {
  return (await ref.watch(
    podcastListPodProvider.selectAsync((e) => e.doc(id.id)),
  ))
      .get();
}

@riverpod
class PodcastListPod extends _$PodcastListPod {
  @override
  Future<CollectionReference<Podcast>> build() async {
    // @TODO: Migrate to let url be id?

    await ref.read(podcastUserPodProvider.future);
    final firestore = ref.watch(podcastUserPodProvider.notifier);

    refreshAll();

    return firestore.userCollection('podcastList').withConverter(
          fromFirestore: Podcast.fromFirestore,
          toFirestore: Podcast.toFirestore,
        );
  }

  Future<void> refreshAll() async {
    await future;
    ref.invalidate(isolateProvider);
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
    // TODO: Should we invalidate or not? (invalidate causes two API calls to each endpoint)
    // ref.invalidate(fetchPodcastProvider(storedPodcast.rssUrl));

    try {
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
      // TODO: Check episodes in [listened] [allEpisodes] and [removedEpisodes] and update those lists
      final allFetchedEpisodes = {
        for (final episode in fetchedEpisodes)
          storedPodcastSnapshot.episodeRef(episode):
              EpisodeHash.fromEpisode(episode),
      };

      // TODO: Check episode hash per episode and update only the changed ones
      if (storedPodcast.episodesHash != episodeHash ||
          storedPodcast.totalEpisodes != fetchedEpisodes.length ||
          true) {
        // If it does NOT match, update the episode list
        await ref
            .read(
              episodeListPodProvider(PodcastId(storedPodcastSnapshot)).notifier,
            )
            .updateList();
      }
      // Update the totalEpisodes with the new value
      // set the episode hash of the "new" [fetchedPodcast] with the hash from the new list
      fetchedPodcast = fetchedPodcast.copyWith(
        episodesHash: episodeHash,
        allEpisodes: allFetchedEpisodes,
        listenedEpisodes: storedPodcast.listenedEpisodes,
        deletedEpisodes: {
          ...storedPodcast.deletedEpisodes,
          for (final (storedEpisodeRef, _) in storedPodcast.allEpisodes.records)
            if (allFetchedEpisodes.keys
                .none((fetchedRef) => storedEpisodeRef.id == fetchedRef.id))
              storedEpisodeRef,
        },
      );
      // endregion Update episodes list

      // If the data we downloaded from the RSS feed is identical,
      // no need to update
      if (storedPodcast != fetchedPodcast) {
        state.requireValue.doc(storedPodcastSnapshot.id).set(fetchedPodcast);
      }
    } on BackpressureDropException catch (_) {
      // noop
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
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

extension on DocumentSnapshot<Podcast> {
  DocumentReference<Episode> episodeRef(Episode episode) {
    return reference
        .collection('episodes')
        .doc(episode.guid)
        .withConverter<Episode>(
          fromFirestore: Episode.fromFirestore,
          toFirestore: Episode.toFirestore,
        );
  }
}
