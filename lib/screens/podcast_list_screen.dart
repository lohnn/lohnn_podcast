import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/providers/firebase/firestore/firestore_provider.dart';
import 'package:podcast/providers/firebase/firestore/podcast_list_pod_provider.dart';
import 'package:podcast/screens/dialogs/add_podcast_dialog.dart';
import 'package:podcast/screens/loading_screen.dart';
import 'package:podcast/widgets/podcast_list_tile.dart';

class PodcastListScreen extends ConsumerWidget {
  const PodcastListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Move back to provider
    final firestore = ref.watch(firestoreProvider.notifier);
    final data = firestore.userCollection('podcastList').withConverter(
      fromFirestore: (snapshot, __) {
        return Podcast.fromJson(snapshot.data()!);
      },
      toFirestore: (podcast, __) {
        return podcast.toJson();
      },
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final rssUrl = await showDialog<String>(
            context: context,
            builder: (context) => const AddPodcastDialog(),
          );
          if (rssUrl == null || !context.mounted) return;

          await LoadingScreen.showLoading(
            context: context,
            job: ref.read(podcastListPodProvider.notifier).addPodcastsToList(
                  rssUrl,
                ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: ref.read(podcastListPodProvider.notifier).refreshAll,
        child: FirestoreListView<Podcast>(
          query: data,
          itemBuilder: (context, snapshot) {
            return PodcastListTile(
              snapshot.data(),
            );
          },
        ),
      ),
    );
  }
}
