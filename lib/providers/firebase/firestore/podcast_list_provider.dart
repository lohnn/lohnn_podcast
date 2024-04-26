import 'package:podcast/data/podcast.dart';
import 'package:podcast/providers/firebase/firestore/firestore_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'podcast_list_provider.g.dart';

@riverpod
Stream<List<Podcast>> podcast(PodcastRef ref) async* {
  await ref.watch(firestoreProvider.future);
  final firestore = ref.watch(firestoreProvider.notifier);
  // TODO: Check if this will continue watching after provider is disposed
  await for (final snapshot in firestore.listen('podcastList')) {
    yield [
      for (final doc in snapshot.docs) Podcast.fromJson(doc.data()),
    ];
  }
}
