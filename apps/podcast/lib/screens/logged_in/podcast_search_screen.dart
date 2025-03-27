import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/providers/find_podcast_provider.dart';
import 'package:podcast/providers/podcasts_provider.dart';
import 'package:podcast/screens/dialogs/add_podcast_dialog.dart';
import 'package:podcast/screens/loading_screen.dart';
import 'package:podcast/screens/modals/podcast_details_modal.dart';
import 'package:podcast/widgets/plasma_sphere_widget.dart';
import 'package:podcast/widgets/rounded_image.dart';

class PodcastSearchScreen extends HookConsumerWidget {
  const PodcastSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Podcasts')),
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
        // @TODO: This should be sticky at the top
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
                  // onTap: () => controller.openView(),
                  // onChanged: (_) => controller.openView(),
                  onChanged: ref.read(findPodcastProvider.notifier).search,
                  trailing: [
                    IconButton(
                      onPressed: () async {
                        final rssUrl = await showDialog<String>(
                          context: context,
                          builder:
                              (context) => GetTextDialog.addPodcastDialog(),
                        );
                        if (rssUrl == null || !context.mounted) return;

                        await LoadingScreen.showLoading(
                          context: context,
                          job: ref
                              .read(findPodcastProvider.notifier)
                              .subscribe(rssUrl),
                        );
                      },
                      icon: const Icon(Icons.rss_feed),
                    ),
                  ],
                );
              },
              suggestionsBuilder: (context, controller) {
                return [];
              },
            ),
          ),
        ),
        if (state.isLoading)
          const SliverFillRemaining(child: Center(child: ParticleLoading()))
        else if (state.hasError)
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverFillRemaining(
              child: Center(
                child: Text(
                  'Something went wrong.\n'
                  'Please send an error report to podcast@lohnn.se with your search term.',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
          )
        else if (state.valueOrNull case final data?)
          SliverList(
            delegate: SliverChildBuilderDelegate(childCount: data.length, (
              context,
              index,
            ) {
              final podcast = data[index];
              return ListTile(
                titleAlignment: ListTileTitleAlignment.titleHeight,
                key: ValueKey(podcast),
                leading: RoundedImage(
                  imageUri: podcast.artwork.uri,
                  imageSize: 40,
                ),
                title: Text(podcast.title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(podcast.author),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final category in podcast.categories.values)
                          Chip(label: Text(category)),
                      ],
                    ),
                  ],
                ),
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
                          .unsubscribe(podcast.url.uri.toString());
                    },
                    icon: const Icon(Icons.check),
                  ),
                  false => IconButton(
                    onPressed: () {
                      ref
                          .read(findPodcastProvider.notifier)
                          .subscribe(podcast.url.uri.toString());
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
