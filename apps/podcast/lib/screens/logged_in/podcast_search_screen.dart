import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/providers/find_podcast_provider.dart';
import 'package:podcast/providers/podcasts_provider.dart';
import 'package:podcast/screens/dialogs/add_podcast_dialog.dart';
import 'package:podcast/screens/loading_screen.dart';
import 'package:podcast/screens/modals/podcast_details_modal.dart';
import 'package:podcast/widgets/podcast_list_tile.dart';

class PodcastSearchScreen extends HookConsumerWidget {
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

class _PodcastSearchScreen extends ConsumerWidget {
  const _PodcastSearchScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(findPodcastProvider);
    // @TODO: This could be cleaned up to be prettier
    final subscribedPodcastsUrls =
        ref
            .watch(
              podcastsProvider.select(
                (state) => state.whenData(
                  (podcasts) => podcasts.map((podcast) => podcast.rssUrl),
                ),
              ),
            )
            .valueOrNull;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          sliver: SliverToBoxAdapter(
            child: SearchAnchor(
              builder: (context, controller) {
                return SearchBar(
                  controller: controller,
                  padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 16),
                  ),
                  leading: const Icon(Icons.search),
                  // onTap: () => controller.openView(),
                  // onChanged: (_) => controller.openView(),
                  onChanged: ref.read(findPodcastProvider.notifier).search,
                );
              },
              suggestionsBuilder: (context, controller) {
                return [];
              },
            ),
          ),
        ),
        if (state.isLoading)
          const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator.adaptive()),
          )
        else if (state.valueOrNull case final data?)
          SliverList(
            delegate: SliverChildBuilderDelegate(childCount: data.length, (
              context,
              index,
            ) {
              final podcast = data[index];
              return PodcastListTile.search(
                key: ValueKey(podcast),
                podcast,
                onTap: () {
                  // @TODO: Set theme color from podcast image
                  showModalBottomSheet(
                    context: context,
                    useSafeArea: true,
                    showDragHandle: true,
                    // @TODO: Eventually maybe show episode list here as well
                    builder: (context) => PodcastDetailsModal(podcast: podcast),
                  );
                },
                trailing: switch (subscribedPodcastsUrls?.contains(
                  podcast.url.uri.toString(),
                )) {
                  null => null,
                  true => IconButton(
                    onPressed: () {
                      ref
                          .read(findPodcastProvider.notifier)
                          .unsubscribe(podcast);
                    },
                    icon: const Icon(Icons.check),
                  ),
                  false => IconButton(
                    onPressed: () {
                      ref.read(findPodcastProvider.notifier).subscribe(podcast);
                    },
                    icon: const Icon(Icons.add),
                  ),
                },
              );
            }),
          ),
      ],
    );
  }
}
