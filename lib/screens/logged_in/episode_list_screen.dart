import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/providers/audio_player_provider.dart';
import 'package:podcast/providers/firebase/firestore/episode_list_pod_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/widgets/rounded_image.dart';

class EpisodeListScreen extends AsyncValueWidget<(Podcast, Query<Episode>)> {
  final PodcastId podcastId;

  const EpisodeListScreen(this.podcastId, {super.key});

  @override
  ProviderBase<AsyncValue<(Podcast, Query<Episode>)>> get provider =>
      episodeListPodProvider(podcastId);

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    AsyncData<(Podcast, Query<Episode>)> data,
  ) {
    final (podcast, query) = data.value;
    return Scaffold(
      appBar: AppBar(title: Text(podcast.name)),
      body: FirestoreListView(
        query: query,
        itemBuilder: (context, snapshot) {
          final episode = snapshot.data();
          return ListTile(
            onTap: () {
              context.go('/${podcastId.id}/${episode.guid}');
            },
            leading: RoundedImage(
              imageUrl: episode.imageUrl ?? podcast.image,
              showDot: !episode.listened,
            ),
            title: Text(episode.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (episode.description case final description?)
                  Text(
                    description,
                    maxLines: 2,
                  ),
                IconButton(
                  onPressed: () {
                    ref
                        .read(audioPlayerPodProvider.notifier)
                        .playEpisode(snapshot);
                  },
                  icon: const Icon(Icons.play_arrow),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
