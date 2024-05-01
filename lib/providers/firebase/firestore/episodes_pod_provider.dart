import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/extensions/keep_alive_link_extensions.dart';
import 'package:podcast/providers/firebase/firestore/podcast_list_pod_provider.dart';
import 'package:podcast/providers/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'episodes_pod_provider.g.dart';

@riverpod
class EpisodesPod extends _$EpisodesPod {
  late CollectionReference<Episode> _episodes;

  @override
  Stream<List<Episode>> build(Podcast podcast) async* {
    ref.watch(podcastListPodProvider);
    _episodes = ref
        .watch(podcastListPodProvider.notifier)
        .collectionForPodcast(
          'episodes',
          podcast,
        )
        .withConverter(
          fromFirestore: (snapshot, _) => Episode.fromJson(snapshot.data()!),
          toFirestore: (data, _) => data.toJson(),
        );

    final episodesQuery = _episodes.orderBy('pubDate', descending: true);
    // If we already have at least some data we yield (and set state) first
    if ((await _episodes.count().get()).count != null) {
      yield (await episodesQuery.get())
          .docs
          .map((e) => e.data())
          .toList(growable: false);
    }

    _updateList();

    await for (final snapshot in episodesQuery.snapshots()) {
      yield snapshot.docs.map((e) => e.data()).toList(growable: false);
    }
  }

  Future<void> _updateList() async {
    ref.keepAlive().tryRunAsync(() async {
      final episodeList =
          await ref.watch(fetchEpisodesProvider(podcast).future);
      for (final downloadedEpisode in episodeList) {
        if (state.valueOrNull
                ?.firstWhereOrNull((e) => e.guid == downloadedEpisode.guid)
            case final storedEpisode?) {
          // Episode already exists in list

          // Does the episode contain any updates?
          if (downloadedEpisode + storedEpisode case final episode
              when episode != storedEpisode) {
            _episodes
                .doc(downloadedEpisode.guid)
                .set(downloadedEpisode + storedEpisode);
          }
        } else {
          // Episode does not exist
          _episodes.doc(downloadedEpisode.guid).set(downloadedEpisode);
        }
      }
    });
  }
}
