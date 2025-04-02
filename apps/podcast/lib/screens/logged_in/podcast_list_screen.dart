import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/podcast_with_status.dart';
import 'package:podcast/providers/podcasts_provider.dart';
import 'package:podcast/providers/podcasts_with_status_provider.dart';
import 'package:podcast/providers/user_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/widgets/podcast_list_tile.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

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
    final avatarUrl = ref.watch(userPodProvider).valueOrNull?.avatarUrl;

    final Widget avatarImage = switch (avatarUrl) {
      final avatarUrl? => CircleAvatar(
        backgroundImage: NetworkImage(avatarUrl),
        radius: 14,
      ),
      _ => const Icon(Icons.account_circle),
    };

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => context.push('/search'),
            icon: const Icon(Icons.search),
          ),
          PopupMenuButton(
            icon: avatarImage,
            itemBuilder:
                (BuildContext context) => [
                  PopupMenuItem(
                    onTap: () {
                      ref.read(podcastsProvider.notifier).refreshAll();
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.refresh),
                        SizedBox(width: 12),
                        Text('Refresh all'),
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

extension on User {
  String? get avatarUrl =>
      userMetadata?['avatar_url'] as String? ??
      userMetadata?['picture'] as String?;
}
