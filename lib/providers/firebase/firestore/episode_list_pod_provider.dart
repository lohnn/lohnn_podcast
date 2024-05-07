import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/providers/firebase/firestore/podcast_list_pod_provider.dart';
import 'package:podcast/providers/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'episode_list_pod_provider.g.dart';

@riverpod
class EpisodeListPod extends _$EpisodeListPod {
  late CollectionReference<Episode> _reference;
  late Podcast _podcast;

  @override
  Future<(Podcast, Query<Episode>)> build(
    PodcastId podcastId,
  ) async {
    _reference =
        (await ref.watch(podcastListPodProvider.notifier).collectionForPodcast(
                  'episodes',
                  podcastId,
                ))
            .withConverter(
      fromFirestore: (snapshot, _) => Episode.fromJson(snapshot.data()!),
      toFirestore: (data, _) => data.toJson(),
    );

    _podcast = (await ref.watch(podcastProvider(podcastId).future)).data()!;

    return (_podcast, _reference.orderBy('pubDate', descending: true));
  }

  Future<void> updateList() async {
    await future;
    final episodeList = await ref.watch(
      fetchEpisodesProvider(_podcast).future,
    );

    final storedDocuments = {
      for (final episodeSnapshot in (await _reference.get()).docs)
        episodeSnapshot.data().guid: episodeSnapshot.data(),
    };

    for (final downloadedEpisode in episodeList) {
      if (storedDocuments[downloadedEpisode.guid] case final storedEpisode?) {
        // Episode already exists in list

        // Does the episode contain any updates?
        if (downloadedEpisode + storedEpisode case final episode
            when episode != storedEpisode) {
          _reference
              .doc(downloadedEpisode.guid)
              .set(downloadedEpisode + storedEpisode);
        }
      } else {
        // Episode does not exist
        _reference.doc(downloadedEpisode.guid).set(downloadedEpisode);
      }
    }
  }
}
