import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/providers/firebase/firestore/podcast_list_pod_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'episodes_pod_provider.g.dart';

@Riverpod(keepAlive: true)
class EpisodesPod extends _$EpisodesPod {
  @override
  Future<Query<Episode>> build(PodcastId podcast) async {
    ref.watch(podcastListPodProvider);
    return (await ref
            .watch(podcastListPodProvider.notifier)
            .collectionForPodcast(
              'episodes',
              podcast,
            ))
        .withConverter(
          fromFirestore: (snapshot, _) => Episode.fromJson(snapshot.data()!),
          toFirestore: (data, _) => data.toJson(),
        )
        .orderBy('pubDate', descending: true);
  }

  Future<void> _updateList() async {
    // ref.keepAlive().tryRunAsync(() async {
    //   final episodeList =
    //       await ref.watch(fetchEpisodesProvider(podcast).future);
    //   for (final downloadedEpisode in episodeList) {
    //     if (state.valueOrNull
    //             ?.firstWhereOrNull((e) => e.guid == downloadedEpisode.guid)
    //         case final storedEpisode?) {
    //       // Episode already exists in list
    //
    //       // Does the episode contain any updates?
    //       if (downloadedEpisode + storedEpisode case final episode
    //           when episode != storedEpisode) {
    //         _episodes
    //             .doc(downloadedEpisode.guid)
    //             .set(downloadedEpisode + storedEpisode);
    //       }
    //     } else {
    //       // Episode does not exist
    //       _episodes.doc(downloadedEpisode.guid).set(downloadedEpisode);
    //     }
    //   }
    // });
  }
}
