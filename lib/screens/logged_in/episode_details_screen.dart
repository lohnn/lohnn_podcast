import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/providers/firebase/firestore/episode_list_pod_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/widgets/play_episode_button.dart';
import 'package:podcast/widgets/pub_date_text.dart';
import 'package:podcast/widgets/rounded_image.dart';

class EpisodeDetailsScreen
    extends AsyncValueWidget<(Podcast, DocumentSnapshot<Episode>)> {
  final PodcastId podcastId;
  final String episodeId;

  const EpisodeDetailsScreen({
    required this.podcastId,
    required this.episodeId,
    super.key,
  });

  @override
  ProviderBase<AsyncValue<(Podcast, DocumentSnapshot<Episode>)>> get provider =>
      episodeProvider(podcastId, episodeId);

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    AsyncData<(Podcast, DocumentSnapshot<Episode>)> data,
  ) {
    final (podcast, episodeSnapshot) = data.value;
    final episode = episodeSnapshot.data();

    return Scaffold(
      appBar: AppBar(),
      body: episode == null
          ? Container()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RoundedImage(imageUri: episode.imageUrl, imageSize: 76),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            podcast.name,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (episode.pubDate case final pubDate?)
                      PubDateText(pubDate),
                    PlayEpisodeButton(episodeSnapshot),
                  ],
                ),
              ),
            ),
    );
  }
}
