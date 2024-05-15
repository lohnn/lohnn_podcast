import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/data/podcast_user.dart';
import 'package:podcast/providers/firebase/firebase_app_provider.dart';
import 'package:podcast/providers/firebase/user_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'podcast_user_pod_provider.g.dart';

@Riverpod(keepAlive: true)
class PodcastUserPod extends _$PodcastUserPod {
  late DocumentReference<PodcastUser> _userDocument;

  @override
  Stream<PodcastUser> build() async* {
    final user = await ref.watch(userPodProvider.future);
    if (user == null) throw Exception('User not available');

    final store = FirebaseFirestore.instanceFor(
      app: await ref.watch(firebaseAppProvider.future),
      databaseId: 'podcast',
    )..settings = const Settings(
        persistenceEnabled: true,
      );

    _userDocument =
        store.collection('users').doc(user.uid).withConverter<PodcastUser>(
      fromFirestore: (snapshot, __) {
        return PodcastUser.fromFirestore(snapshot.data()!);
      },
      toFirestore: (podcastUser, __) {
        return podcastUser.toFirestore();
      },
    );

    await for (final snapshot in _userDocument.snapshots()) {
      if (snapshot.data() case final podcastUser?) {
        yield podcastUser;
      } else {
        yield const PodcastUser();
      }
    }
  }

  Future<void> setQueue(List<DocumentReference<Episode>> queue) async {
    final user = await future;
    return _userDocument.set(user.copyWith(playQueue: queue));
  }

  /// Removes the episode from the queue and returns the next episode in the queue
  Future<DocumentReference<Episode>?> removeFromQueue(
    DocumentReference<Episode> episode,
  ) async {
    final user = await future;
    final queue = [
      for (final ref in user.playQueue)
        if (ref.id != episode.id) ref,
    ];
    await setQueue(queue);
    return queue.firstOrNull;
  }

  Future<void> addToQueue(DocumentReference<Episode> episode) async {
    final user = await future;
    return setQueue([
      ...user.playQueue,
      // Don't add if already in queue
      if (user.playQueue.firstWhereOrNull((e) => e.id == episode.id) == null)
        episode,
    ]);
  }

  Future<void> addToTopOfQueue(DocumentReference<Episode> episode) async {
    final user = await future;
    return setQueue([
      episode,
      for (final oldQueueItem in user.playQueue)
        if (oldQueueItem.id != episode.id) oldQueueItem,
    ]);
  }

  CollectionReference<Map<String, dynamic>> userCollection(
    String collectionPath,
  ) {
    return _userDocument.collection(collectionPath);
  }
}
