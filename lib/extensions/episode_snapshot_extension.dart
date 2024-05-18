import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/data/podcast.dart';

extension EpisodeSnapshotExtension on DocumentSnapshot<Episode> {
  Future<void> markUnlistened() async {
    if (data() case final currentEpisode?) {
      await reference.set(currentEpisode.copyWith(listened: false));
    }

    // Add episode reference to the podcast's "listenedList"
    final podcastReference = reference.podcast;
    final podcast = (await podcastReference.get()).data()!;
    await podcastReference.set(
      podcast.copyWith(
        listenedEpisodes: {
          for (final episode in podcast.listenedEpisodes)
            if (episode.id != reference.id) episode,
        },
      ),
    );
  }

  Future<void> markListened() async {
    if (data() case final currentEpisode?) {
      await reference.set(currentEpisode.copyWith(listened: true));

      // Add episode reference to the podcast's "listenedList"
      final podcastReference = reference.podcast;
      final podcast = (await podcastReference.get()).data()!;
      await podcastReference.set(
        podcast.copyWith(
          listenedEpisodes: {
            // Just make damn sure we don't add an episode more than once
            for (final (episode) in podcast.listenedEpisodes)
              if (episode.id != reference.id) episode,
            reference,
          },
        ),
      );
    }
  }
}

extension on DocumentReference<Episode> {
  DocumentReference<Podcast> get podcast => parent.parent!.withConverter(
        fromFirestore: Podcast.fromFirestore,
        toFirestore: Podcast.toFirestore,
      );
}
