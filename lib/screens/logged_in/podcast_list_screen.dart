import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/podcast.model.dart';
import 'package:podcast/providers/podcasts_provider.dart';
import 'package:podcast/providers/user_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/screens/dialogs/add_podcast_dialog.dart';
import 'package:podcast/screens/loading_screen.dart';
import 'package:podcast/widgets/podcast_list_tile.dart';

class PodcastListScreen extends AsyncValueWidget<List<Podcast>> {
  const PodcastListScreen({super.key});

  @override
  ProviderBase<AsyncValue<List<Podcast>>> get provider => podcastsProvider;

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    List<Podcast> podcasts,
  ) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => context.push('/search'),
            icon: const Icon(Icons.search),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) => [
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
          final podcast = podcasts[index];
          return PodcastListTile(podcast);
        },
      ),
    );
  }
}
