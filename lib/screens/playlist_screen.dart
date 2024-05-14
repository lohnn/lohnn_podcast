import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/extensions/string_extensions.dart';
import 'package:podcast/providers/firebase/firestore/podcast_user_pod_provider.dart';
import 'package:podcast/providers/firebase/playlist_pod_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/widgets/play_episode_button.dart';
import 'package:podcast/widgets/pub_date_text.dart';
import 'package:podcast/widgets/rounded_image.dart';

class PlaylistScreen extends AsyncValueWidget<List<DocumentSnapshot<Episode>>> {
  const PlaylistScreen({super.key});

  @override
  ProviderBase<AsyncValue<List<DocumentSnapshot<Episode>>>> get provider =>
      playlistPodProvider;

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    AsyncData<List<DocumentSnapshot<Episode>>> data,
  ) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
          itemCount: data.value.length,
          itemBuilder: (context, index) {
            final snapshot = data.value[index];
            final episode = snapshot.data()!;

            return ListTile(
              onTap: () {
                // context.push('/${podcastId.id}/${episode.guid}');
              },
              leading: RoundedImage(
                imageUri: episode.imageUrl,
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
                  Row(
                    children: [
                      PlayEpisodeButton(snapshot),
                      IconButton(
                        onPressed: () {
                          ref
                              .read(podcastUserPodProvider.notifier)
                              .addToQueue(snapshot.reference);
                        },
                        icon: const Icon(Icons.playlist_add),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
