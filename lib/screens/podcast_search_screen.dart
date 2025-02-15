import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/podcast.model.dart';
import 'package:podcast/providers/find_podcast_provider.dart';
import 'package:podcast/providers/podcasts_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/screens/dialogs/add_podcast_dialog.dart';
import 'package:podcast/screens/loading_screen.dart';
import 'package:podcast/widgets/podcast_list_tile.dart';

class PodcastSearchScreen extends ConsumerWidget {
  const PodcastSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Podcasts')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final rssUrl = await showDialog<String>(
            context: context,
            builder: (context) => GetTextDialog.addPodcastDialog(),
          );
          if (rssUrl == null || !context.mounted) return;

          await LoadingScreen.showLoading(
            context: context,
            job: ref.read(podcastsProvider.notifier).addPodcastToList(rssUrl),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: const _PodcastSearchScreen(),
    );
  }
}

class _PodcastSearchScreen
    extends AsyncValueWidget<List<({Podcast podcast, bool isSubscribed})>> {
  const _PodcastSearchScreen({super.key});

  @override
  ProviderBase<AsyncValue<List<({Podcast podcast, bool isSubscribed})>>>
  get provider => findPodcastProvider;

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    List<({Podcast podcast, bool isSubscribed})> data,
  ) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final (:podcast, :isSubscribed) = data[index];
        return PodcastListTile(
          key: ValueKey(podcast),
          podcast,
          trailing:
              isSubscribed
                  ? IconButton(
                    onPressed: () {
                      ref
                          .read(findPodcastProvider.notifier)
                          .unsubscribe(podcast);
                    },
                    icon: const Icon(Icons.check),
                  )
                  : IconButton(
                    onPressed: () {
                      ref.read(findPodcastProvider.notifier).subscribe(podcast);
                    },
                    icon: const Icon(Icons.add),
                  ),
        );
      },
    );
  }
}
