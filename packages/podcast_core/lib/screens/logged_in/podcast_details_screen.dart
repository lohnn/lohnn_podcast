import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/data/episode_with_status.dart';
import 'package:podcast_core/data/podcast.model.dart';
import 'package:podcast_core/extensions/string_extensions.dart';
import 'package:podcast_core/providers/episodes_provider.dart';
import 'package:podcast_core/screens/async_value_screen.dart';
import 'package:podcast_core/widgets/play_episode_button.dart';
import 'package:podcast_core/widgets/podcast_details.dart';
import 'package:podcast_core/widgets/pub_date_text.dart';
import 'package:podcast_core/widgets/queue_button.dart';
import 'package:podcast_core/widgets/rounded_image.dart';

class PodcastDetailsScreen
    extends AsyncValueWidget<(Podcast, List<EpisodeWithStatus>)> {
  final PodcastId podcastId;

  const PodcastDetailsScreen(this.podcastId, {super.key});

  @override
  EpisodesProvider get provider => episodesProvider(podcastId: podcastId);

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    (Podcast, List<EpisodeWithStatus>) data,
  ) {
    final (podcast, episodes) = data;

    useEffect(() {
      unawaited(ref.read(provider.notifier).updateLastSeen());
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(title: Text(podcast.title)),
      body: RefreshIndicator(
        onRefresh: ref.read(provider.notifier).updateList,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverToBoxAdapter(
                child: PodcastDetails.fromList(podcast: podcast),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            const SliverToBoxAdapter(child: Divider()),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverList.builder(
              itemCount: episodes.length,
              itemBuilder: (context, index) {
                final episodeWithStatus = episodes[index];
                return ListTile(
                  key: ValueKey(episodeWithStatus.episode.id),
                  onTap: () {
                    context.push(
                      '/${podcast.id.safe}/${episodeWithStatus.episode.id.safe}',
                    );
                  },
                  leading: Tooltip(
                    message: switch (episodeWithStatus.isPlayed) {
                      true => 'Played episode',
                      false => 'Unplayed episode',
                    },
                    child: RoundedImage(
                      imageUri: episodeWithStatus.episode.imageUrl,
                      showDot: !episodeWithStatus.isPlayed,
                      imageSize: 40,
                    ),
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
                          QueueButton(episode: episodeWithStatus.episode),
                        ],
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<_PopupActions>(
                    itemBuilder:
                        (context) => [
                          if (episodeWithStatus.isPlayed)
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
          ],
        ),
      ),
    );
  }
}

enum _PopupActions { markListened, markUnlistened }
