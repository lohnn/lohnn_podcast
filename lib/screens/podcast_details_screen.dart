import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/providers/firebase/firestore/episodes_pod_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/widgets/rounded_image.dart';

class PodcastDetailsScreen extends AsyncValueWidget<Query<Episode>> {
  final PodcastId podcastId;
  final Podcast podcast;

  const PodcastDetailsScreen(this.podcastId, this.podcast, {super.key});

  @override
  ProviderBase<AsyncValue<Query<Episode>>> get provider =>
      episodesPodProvider(podcastId);

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    AsyncData<Query<Episode>> data,
  ) {
    return Scaffold(
      appBar: AppBar(title: Text(podcast.name)),
      body: FirestoreListView(
        query: data.value,
        itemBuilder: (context, snapshot) {
          final episode = snapshot.data();
          return ListTile(
            leading: RoundedImage(
              imageUrl: episode.imageUrl ?? podcast.image,
              showDot: !episode.listened,
            ),
            title: Text(episode.title),
          );
        },
      ),
    );
  }
}
