import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/episode.model.dart';
import 'package:podcast/extensions/string_extensions.dart';
import 'package:podcast/providers/playlist_pod_provider.dart';
import 'package:podcast/providers/user_episode_status_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/widgets/play_episode_button.dart';
import 'package:podcast/widgets/pub_date_text.dart';
import 'package:podcast/widgets/rounded_image.dart';

class PlaylistScreen extends AsyncValueWidget<List<Episode>> {
  const PlaylistScreen({super.key});

  @override
  ProviderBase<AsyncValue<List<Episode>>> get provider => playlistPodProvider;

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    List<Episode> data,
  ) {
    return Scaffold(
      appBar: AppBar(),
      body: ReorderableListView.builder(
        onReorder: (oldIndex, newIndex) {
          ref.read(playlistPodProvider.notifier).reorder(oldIndex, newIndex);
        },
        itemCount: data.length,
        itemBuilder: (context, index) {
          final episode = data[index];

          final valueOrNull2 =
              ref.read(userEpisodeStatusPodProvider).valueOrNull;
          return ListTile(
            key: ValueKey(episode),
            onTap: () {
              // context.push('/${podcastId.id}/${episode.guid}');
            },
            leading: RoundedImage(
              imageUri: episode.imageUrl.uri,
              // TODO: Do this more prettier
              showDot: !(valueOrNull2?[episode.id]?.isPlayed ?? false),
              imageSize: 40,
            ),
            title: Column(
              mainAxisSize: MainAxisSize.min,
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
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (episode.description case final description?)
                  Text(
                    description.removeHtmlTags(),
                    maxLines: 2,
                  ),
                Row(
                  children: [
                    PlayEpisodeButton(episode),
                    IconButton(
                      onPressed: () {
                        ref
                            .read(playlistPodProvider.notifier)
                            .removeFromQueue(episode);
                      },
                      icon: const Icon(Icons.playlist_remove),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
