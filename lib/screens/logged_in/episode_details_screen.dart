import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/providers/firebase/firestore/episode_list_pod_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';

class EpisodeDetailsScreen extends AsyncValueWidget<DocumentSnapshot<Episode>> {
  final PodcastId podcastId;
  final String episodeId;

  const EpisodeDetailsScreen({
    required this.podcastId,
    required this.episodeId,
    super.key,
  });

  @override
  ProviderBase<AsyncValue<DocumentSnapshot<Episode>>> get provider =>
      episodeProvider(podcastId, episodeId);

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    AsyncData<DocumentSnapshot<Episode>> data,
  ) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }
}
