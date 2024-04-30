import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/extensions/map_extensions.dart';
import 'package:podcast/providers/firebase/firestore/podcast_pod_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/screens/dialogs/add_podcast_dialog.dart';
import 'package:podcast/screens/loading_screen.dart';
import 'package:podcast/widgets/podcast_list_tile.dart';

class PodcastScreen extends AsyncValueWidget<Map<PodcastId, Podcast>> {
  const PodcastScreen({super.key});

  @override
  ProviderBase<AsyncValue<Map<PodcastId, Podcast>>> get provider =>
      podcastPodProvider;

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    AsyncData<Map<PodcastId, Podcast>> data,
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
            job: ref.read(podcastPodProvider.notifier).addPodcastsToList(
                  rssUrl,
                ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: ref.read(podcastPodProvider.notifier).refreshAll,
        child: ListView(
          children: [
            for (final (_, podcast) in data.value.records)
              PodcastListTile(podcast),
          ],
        ),
      ),
    );
  }
}
