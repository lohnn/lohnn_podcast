import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/extensions/string_extensions.dart';
import 'package:podcast/providers/firebase/firestore/episode_list_pod_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/widgets/play_episode_button.dart';
import 'package:podcast/widgets/pub_date_text.dart';
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
        query: query.orderBy('pubDate', descending: true),
        itemBuilder: (context, snapshot) {
          final episode = snapshot.data();
          return ListTile(
            onTap: () {
              context.push('/${podcastId.id}/${episode.guid}');
            },
            leading: RoundedImage(
              imageUrl: episode.imageUrl ?? podcast.image,
              showDot: !episode.listened,
              imageSize: 40,
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (episode.pubDate case final pubDate?)
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w200,
                    ),
                    child: PubDateText(pubDate),
                  ),
                Text(episode.title),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (episode.description case final description?)
                  Text(
                    description.removeHtmlTags(),
                    maxLines: 2,
                  ),
                PlayEpisodeButton(episode),
              ],
            ),
          );
        },
      ),
    );
  }
}
