import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/episode_with_status.dart';
import 'package:podcast/data/podcast.model.dart';
import 'package:podcast/extensions/string_extensions.dart';
import 'package:podcast/providers/episodes_provider.dart';
import 'package:podcast/providers/playlist_pod_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/widgets/play_episode_button.dart';
import 'package:podcast/widgets/pub_date_text.dart';
import 'package:podcast/widgets/rounded_image.dart';

class EpisodeListScreen
    extends AsyncValueWidget<(Podcast, List<EpisodeWithStatus>)> {
  final String podcastId;

  const EpisodeListScreen(this.podcastId, {super.key});

  @override
  EpisodesProvider get provider => episodesProvider(podcastId: podcastId);

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    (Podcast, List<EpisodeWithStatus>) data,
  ) {
    // TODO: Verify why provider is rebuilding multiple times
    final queue = ref.watch(playlistPodProvider).valueOrNull ?? [];
    final (podcast, episodes) = data;
    return Scaffold(
      appBar: AppBar(title: Text(podcast.name)),
      body: RefreshIndicator(
        onRefresh: ref.read(provider.notifier).updateList,
        child: ListView.builder(
          itemCount: episodes.length,
          itemBuilder: (context, index) {
            final episodeWithStatus = episodes[index];
            return ListTile(
              key: ValueKey(episodeWithStatus.episode.id),
              onTap: () {
                context.push(
                  '/${podcast.safeId}/${episodeWithStatus.episode.safeId}',
                );
              },
              leading: RoundedImage(
                imageUri: episodeWithStatus.episode.imageUrl.uri,
                showDot: !episodeWithStatus.status.isPlayed,
                imageSize: 40,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (episodeWithStatus.episode.pubDate case final pubDate?)
                    DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w200,
                      ),
                      child: PubDateText(pubDate),
                    ),
                  Text(episodeWithStatus.episode.title),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (episodeWithStatus.episode.description
                      case final description?)
                    Text(description.removeHtmlTags(), maxLines: 2),
                  Row(
                    children: [
                      PlayEpisodeButton(episodeWithStatus.episode),
                      if (queue.contains(episodeWithStatus.episode))
                        IconButton(
                          onPressed: () {
                            ref
                                .read(playlistPodProvider.notifier)
                                .removeFromQueue(episodeWithStatus.episode);
                          },
                          icon: const Icon(Icons.playlist_remove),
                        )
                      else
                        IconButton(
                          onPressed: () {
                            ref
                                .read(playlistPodProvider.notifier)
                                .addToBottomOfQueue(episodeWithStatus.episode);
                          },
                          icon: const Icon(Icons.playlist_add),
                        ),
                    ],
                  ),
                ],
              ),
              trailing: PopupMenuButton<_PopupActions>(
                itemBuilder:
                    (context) => [
                      if (episodeWithStatus.status.isPlayed)
                        const PopupMenuItem(
                          value: _PopupActions.markUnlistened,
                          child: Text('Mark unlistened'),
                        )
                      else
                        const PopupMenuItem(
                          value: _PopupActions.markListened,
                          child: Text('Mark listened'),
                        ),
                    ],
                icon: const Icon(Icons.more_vert),
                onSelected: (value) async {
                  switch (value) {
                    case _PopupActions.markListened:
                      await ref
                          .read(provider.notifier)
                          .markListened(episodeWithStatus);
                    case _PopupActions.markUnlistened:
                      await ref
                          .read(provider.notifier)
                          .markUnlistened(episodeWithStatus);
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

enum _PopupActions { markListened, markUnlistened }
