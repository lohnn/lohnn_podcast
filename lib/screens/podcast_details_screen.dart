import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/providers/firebase/firestore/episodes_pod_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/widgets/rounded_image.dart';

class PodcastDetailsScreen extends AsyncValueWidget<List<Episode>> {
  final Podcast podcast;

  const PodcastDetailsScreen(this.podcast, {super.key});

  @override
  ProviderBase<AsyncValue<List<Episode>>> get provider =>
      episodesPodProvider(podcast);

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    AsyncData<List<Episode>> data,
  ) {
    return Scaffold(
      appBar: AppBar(title: Text(podcast.name)),
      body: ListView.builder(
        itemCount: data.value.length,
        itemBuilder: (context, index) {
          final episode = data.value[index];
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
