import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/extensions/duration_extensions.dart';
import 'package:podcast_core/extensions/string_extensions.dart';
import 'package:podcast_core/widgets/play_episode_button.dart';
import 'package:podcast_core/widgets/pub_date_text.dart';
import 'package:podcast_core/widgets/queue_button.dart';
import 'package:podcast_core/widgets/rounded_image.dart';

class EpisodeListItem extends StatelessWidget {
  final Episode episodeWithStatus;
  final bool isPlayed;
  final Widget? trailing;

  const EpisodeListItem({
    super.key,
    required this.episodeWithStatus,
    required this.isPlayed,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      key: ValueKey(episodeWithStatus.id),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: () {
          context.push(
            '/${episodeWithStatus.podcastId.safe}/${episodeWithStatus.id.safe}',
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Tooltip(
                message: switch (isPlayed) {
                  true => 'Played episode',
                  false => 'Unplayed episode',
                },
                child: RoundedImage(
                  imageUri: episodeWithStatus.imageUrl,
                  showDot: !isPlayed,
                  imageSize: 40,
                ),
              ),
              Expanded(
                child: Column(
                  spacing: 6,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: theme.textTheme.bodySmall!.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w200,
                      ),
                      child: RichText(
                        text: TextSpan(
                          children: [
                            if (episodeWithStatus.pubDate case final pubDate?)
                              WidgetSpan(child: PubDateText(pubDate)),
                            if (episodeWithStatus.duration case final duration?)
                              TextSpan(
                                text: ' • ${duration.prettyPrint()}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      episodeWithStatus.title,
                      style: theme.textTheme.titleSmall,
                    ),
                    if (episodeWithStatus.description case final description?)
                      Text(
                        description.removeHtmlTags(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    Row(
                      spacing: 8,
                      children: [
                        PlayEpisodeButton(episodeWithStatus),
                        QueueButton(episode: episodeWithStatus),
                      ],
                    ),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    );
  }
}
