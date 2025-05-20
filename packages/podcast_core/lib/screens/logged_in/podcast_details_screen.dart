import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/data/episode_with_status.dart';
import 'package:podcast_core/data/podcast.model.dart';
import 'package:podcast_core/hooks/menu_controller_hook.dart';
import 'package:podcast_core/providers/episodes_filter_provider.dart';
import 'package:podcast_core/providers/episodes_provider.dart';
import 'package:podcast_core/screens/async_value_screen.dart';
import 'package:podcast_core/widgets/episode_list_item.dart';
import 'package:podcast_core/widgets/filter_episodes_popup.dart';
import 'package:podcast_core/widgets/podcast_details.dart';

class PodcastDetailsScreen
    extends AsyncValueWidget<(Podcast, List<EpisodeWithStatus>)> {
  final PodcastId podcastId;

  const PodcastDetailsScreen(this.podcastId, {super.key});

  @override
  EpisodesProvider get provider => episodesProvider(podcastId: podcastId);

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    (Podcast, List<EpisodeWithStatus>) data,
  ) {
    final (podcast, episodes) = data;

    useEffect(() {
      unawaited(ref.read(provider.notifier).updateLastSeen());
      return null;
    }, []);

    final filterMenuController = useMenuController();

    final episodesFilterState = ref.watch(episodesFilterProvider);

    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(podcast.title)),
      body: RefreshIndicator(
        onRefresh: ref.read(provider.notifier).updateList,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: SliverToBoxAdapter(
                child: PodcastDetails.fromList(podcast: podcast),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverToBoxAdapter(
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MenuAnchor(
                      style: MenuStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          theme.colorScheme.surfaceContainerHigh,
                        ),
                        fixedSize: const WidgetStatePropertyAll(
                          Size.fromWidth(400),
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      crossAxisUnconstrained: false,
                      controller: filterMenuController,
                      menuChildren: const [FilterEpisodesPopup()],
                      child: IconButton(
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Icon(
                            Icons.filter_list,
                            key: ValueKey(episodesFilterState.isDefault),
                            color:
                                episodesFilterState.isDefault
                                    ? theme.colorScheme.primary.withValues(alpha: 0.6)
                                    : theme.colorScheme.primary,
                          ),
                        ),
                        onPressed: () {
                          if (filterMenuController.isOpen) {
                            filterMenuController.close();
                          } else {
                            filterMenuController.open();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(child: Divider()),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverList.builder(
              itemCount: episodes.length,
              itemBuilder: (context, index) {
                final episodeWithStatus = episodes[index];
                return EpisodeListItem(
                  episodeWithStatus: episodeWithStatus,
                  onMarkListenedPressed: () async {
                    await ref
                        .read(provider.notifier)
                        .markListened(episodeWithStatus);
                  },
                  onMarkUnlistenedPressed: () async {
                    await ref
                        .read(provider.notifier)
                        .markUnlistened(episodeWithStatus);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
