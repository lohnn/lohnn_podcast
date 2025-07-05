import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/gen/strings.g.dart';
import 'package:podcast_core/providers/find_podcast_provider.dart';
import 'package:podcast_core/providers/podcasts_provider.dart';
import 'package:podcast_core/screens/modals/podcast_details_modal.dart';
import 'package:podcast_core/widgets/plasma_sphere_widget.dart';
import 'package:podcast_core/widgets/rounded_image.dart';

class PodcastSearchScreen extends ConsumerWidget {
  const PodcastSearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(findPodcastProvider);
    return Scaffold(
      appBar: AppBar(
        title: SearchAnchor(
          builder: (context, controller) {
            return SearchBar(
              autoFocus: true,
              hintText: context.t.podcastSearchScreen.searchForPodcasts,
              controller: controller,
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: ref.read(findPodcastProvider.notifier).search,
              trailing: const [
                // @TODO: Implement somehow
                // IconButton(
                //   onPressed: () async {
                //     final rssUrl = await showDialog<String>(
                //       context: context,
                //       builder: (context) => GetTextDialog.addPodcastDialog(),
                //     );
                //     if (rssUrl == null || !context.mounted) return;
                //
                //     await LoadingScreen.showLoading(
                //       context: context,
                //       job: ref
                //           .read(findPodcastProvider.notifier)
                //           .subscribe(rssUrl),
                //     );
                //   },
                //   icon: const Icon(Icons.rss_feed),
                // ),
              ],
            );
          },
          suggestionsBuilder: (context, controller) {
            return [];
          },
        ),
      ),
      body: CustomScrollView(
        slivers: [
          if (state.isLoading)
            const SliverFillRemaining(child: Center(child: ParticleLoading()))
          else if (state.hasError)
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverFillRemaining(
                child: Center(
                  child: Text(
                    context.t.podcastSearchScreen.somethingWentWrong,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
            )
          else if (state.value case final data?)
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
                    semanticLabel: context.t.podcastSearchScreen.podcastArtwork,
                    imageUri: podcast.artwork,
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
                      builder: (context) =>
                          PodcastSearchDetailsModal(podcast: podcast),
                    );
                  },
                  trailing: switch (ref
                      .watch(subscribedPodcastProvider(rssUrl: podcast.url))
                      .value) {
                    null => null,
                    true => IconButton(
                      onPressed: () {
                        ref
                            .read(findPodcastProvider.notifier)
                            .unsubscribe(podcast.url);
                      },
                      icon: const Icon(Icons.check),
                    ),
                    false => IconButton(
                      onPressed: () {
                        ref
                            .read(findPodcastProvider.notifier)
                            .subscribe(podcast.url);
                      },
                      icon: const Icon(Icons.add),
                    ),
                  },
                );
              }),
            ),
        ],
      ),
    );
  }
}
