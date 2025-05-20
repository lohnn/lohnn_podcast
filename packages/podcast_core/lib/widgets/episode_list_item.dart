import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:podcast_core/data/episode_with_status.dart';
import 'package:podcast_core/extensions/duration_extensions.dart';
import 'package:podcast_core/extensions/string_extensions.dart';
import 'package:podcast_core/widgets/play_episode_button.dart';
import 'package:podcast_core/widgets/pub_date_text.dart';
import 'package:podcast_core/widgets/queue_button.dart';
import 'package:podcast_core/widgets/rounded_image.dart';

class EpisodeListItem extends StatelessWidget {
  final EpisodeWithStatus episodeWithStatus;
  final VoidCallback onMarkListenedPressed;
  final VoidCallback onMarkUnlistenedPressed;

  const EpisodeListItem({
    super.key,
    required this.episodeWithStatus,
    required this.onMarkListenedPressed,
    required this.onMarkUnlistenedPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: ValueKey(episodeWithStatus.episode.id),
      onTap: () {
        context.push(
          '/${episodeWithStatus.episode.podcastId.safe}/${episodeWithStatus.episode.id.safe}',
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
          DefaultTextStyle(
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w200,
            ),
            child: Row(
              children: [
                if (episodeWithStatus.episode.pubDate case final pubDate?)
                  PubDateText(pubDate),
                if (episodeWithStatus.episode.duration case final duration?)
                  Text(
                    ' • ${duration.prettyPrint()}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
              ],
            ),
          ),
          Text(episodeWithStatus.episode.title),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (episodeWithStatus.episode.description case final description?)
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
        onSelected: (value) {
          switch (value) {
            case _PopupActions.markListened:
              onMarkListenedPressed();
            case _PopupActions.markUnlistened:
              onMarkUnlistenedPressed();
          }
        },
      ),
    );
  }
}

enum _PopupActions { markListened, markUnlistened }
