import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/data/podcast_with_status.dart';
import 'package:podcast_core/providers/podcasts_with_status_provider.dart';
import 'package:podcast_core/screens/async_value_screen.dart';
import 'package:podcast_core/widgets/podcast_list_tile.dart';

class PodcastListScreen extends AsyncValueWidget<List<PodcastWithStatus>> {
  const PodcastListScreen({super.key});

  @override
  ProviderBase<AsyncValue<List<PodcastWithStatus>>> get provider =>
      podcastsWithStatusProvider;

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    List<PodcastWithStatus> podcasts,
  ) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => context.push('/search'),
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(childCount: podcasts.length, (
              context,
              index,
            ) {
              {
                final PodcastWithStatus(
                  :podcast,
                  :listenedEpisodes,
                  :totalEpisodes,
                  :hasUnseenEpisodes,
                ) = podcasts[index];

                return PodcastListTile.podcast(
                  podcast,
                  showDot: hasUnseenEpisodes,
                  onTap: () {
                    context.push('/${podcast.id}', extra: podcast);
                  },
                  trailing: Text(
                    '${listenedEpisodes ?? '?'}/${totalEpisodes ?? '?'}',
                  ),
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
