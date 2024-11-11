import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/providers/firebase/firestore/podcast_list_pod_provider.dart';
import 'package:podcast/providers/firebase/user_provider.dart';
import 'package:podcast/providers/podcasts_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/screens/dialogs/add_podcast_dialog.dart';
import 'package:podcast/screens/loading_screen.dart';
import 'package:podcast/widgets/podcast_list_tile.dart';
import 'package:podcast/widgets/podcast_supabase_list_tile.dart';

class PodcastListScreen extends AsyncValueWidget<Query<Podcast>> {
  const PodcastListScreen({super.key});

  @override
  ProviderBase<AsyncValue<Query<Podcast>>> get provider =>
      podcastListPodProvider;

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    Query<Podcast> data,
  ) {
    final podcasts = ref.watch(podcastsProvider);

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
                  ref.read(podcastListPodProvider.notifier).refreshAll();
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
                onTap: () async {
                  final url = await showDialog<String>(
                    context: context,
                    builder: (context) =>
                        GetTextDialog.importListenedEpisodesDialog(),
                  );
                  if (url == null || !context.mounted) return;

                  final failedEpisodes = await LoadingScreen.showLoading(
                    context: context,
                    job: ref
                        .read(podcastListPodProvider.notifier)
                        .importListenedEpisodes(
                          url,
                        ),
                  );

                  if (failedEpisodes.isNotEmpty && context.mounted) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Some episodes failed'),
                          content: SingleChildScrollView(
                            child: Text(
                              'Some episodes failed to download:\n'
                              '${const JsonEncoder.withIndent('  ').convert(failedEpisodes)}',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Ok'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 12),
                    Text('Import listened episodes'),
                  ],
                ),
              ),
              PopupMenuItem(
                onTap: () async {
                  await LoadingScreen.showLoading(
                    context: context,
                    job: ref
                        .read(podcastListPodProvider.notifier)
                        .exportListenedEpisodes(),
                  );
                },
                child: const Row(
                  children: [
                    Icon(Icons.upload),
                    SizedBox(width: 12),
                    Text('Export listened episodes'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final rssUrl = await showDialog<String>(
            context: context,
            builder: (context) => GetTextDialog.addPodcastDialog(),
          );
          if (rssUrl == null || !context.mounted) return;

          await LoadingScreen.showLoading(
            context: context,
            job: ref.read(podcastListPodProvider.notifier).addPodcastToList(
                  rssUrl,
                ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: switch (false) {
        false => ListView.builder(
            itemCount: podcasts.valueOrNull?.length ?? 0,
            itemBuilder: (context, index) {
              final podcast = podcasts.requireValue[index];
              return PodcastSupabaseListTile(podcast);
            },
          ),
        true => FirestoreListView<Podcast>(
            query: data,
            itemBuilder: (context, snapshot) {
              return PodcastListTile(snapshot);
            },
          ),
      },
    );
  }
}
