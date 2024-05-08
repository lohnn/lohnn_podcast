import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/providers/firebase/firestore/podcast_list_pod_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/screens/dialogs/add_podcast_dialog.dart';
import 'package:podcast/screens/loading_screen.dart';
import 'package:podcast/widgets/podcast_list_tile.dart';

class PodcastListScreen extends AsyncValueWidget<Query<Podcast>> {
  const PodcastListScreen({super.key});

  @override
  ProviderBase<AsyncValue<Query<Podcast>>> get provider =>
      podcastListPodProvider;

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    AsyncData<Query<Podcast>> data,
  ) {
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
          query: data.value,
          itemBuilder: (context, snapshot) {
            return PodcastListTile(
              PodcastId(snapshot.id),
              snapshot.data(),
            );
          },
        ),
      ),
    );
  }
}
