import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/podcast_with_status.dart';
import 'package:podcast/providers/podcasts_provider.dart';
import 'package:podcast/providers/podcasts_with_status_provider.dart';
import 'package:podcast/providers/user_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/widgets/avatar_circle.dart';
import 'package:podcast/widgets/podcast_list_tile.dart';

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
          PopupMenuButton(
            icon: const AvatarCircle(),
            itemBuilder:
                (BuildContext context) => [
                  if (kDebugMode)
                    PopupMenuItem(
                      onTap: () {
                        ref.read(podcastsProvider.notifier).refreshAll();
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.refresh),
                          SizedBox(width: 12),
                          Text('Refresh all podcasts'),
                        ],
                      ),
                    ),
                  PopupMenuItem(
                    onTap: () {
                      ref.read(userPodProvider.notifier).logOut();
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.logout),
                        SizedBox(width: 12),
                        Text('Log out'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: podcasts.length,
        itemBuilder: (context, index) {
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
              context.push('/${podcast.safeId}', extra: podcast);
            },
            trailing: Text(
              '${listenedEpisodes ?? '?'}/${totalEpisodes ?? '?'}',
            ),
          );
        },
      ),
    );
  }
}
