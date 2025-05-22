import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/data/episode_with_status.dart';
import 'package:podcast_core/data/podcast.model.dart';
import 'package:podcast_core/providers/color_scheme_from_remote_image_provider.dart';
import 'package:podcast_core/providers/episodes_provider.dart';
import 'package:podcast_core/screens/async_value_screen.dart';
import 'package:podcast_core/widgets/play_episode_button.dart';
import 'package:podcast_core/widgets/pub_date_text.dart';
import 'package:podcast_core/widgets/queue_button.dart';
import 'package:podcast_core/widgets/rounded_image.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EpisodeDetailsScreen
    extends AsyncValueWidget<(Podcast, EpisodeWithStatus)> {
  final PodcastId podcastId;
  final EpisodeId episodeId;

  const EpisodeDetailsScreen({
    required this.podcastId,
    required this.episodeId,
    super.key,
  });

  @override
  EpisodePodProvider get provider =>
      episodePodProvider(podcastId: podcastId, episodeId: episodeId);

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    (Podcast, EpisodeWithStatus) data,
  ) {
    final (podcast, episodeWithStatus) = data;
    final episode = episodeWithStatus.episode;

    return Scaffold(
      appBar: AppBar(),
      body: AnimatedTheme(
        data: Theme.of(context).copyWith(
          colorScheme: ref
              .watch(
                colorSchemeFromRemoteImageProvider(
                  episode.imageUrl,
                  Theme.of(context).brightness,
                ),
              )
              .value,
        ),
        key: const Key('EpisodeDetailsScreen.theme'),
        child: SelectableRegion(
          selectionControls: materialTextSelectionControls,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RoundedImage(imageUri: episode.imageUrl, imageSize: 100),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              podcast.title,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              episode.title,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (episode.pubDate case final pubDate?) PubDateText(pubDate),
                  Row(
                    children: [
                      PlayEpisodeButton(episode),
                      QueueButton(episode: episode),
                    ],
                  ),
                  if (episode.description case final description?) ...[
                    const SizedBox(height: 16),
                    HtmlWidget(
                      description,
                      onTapUrl: (url) {
                        launchUrlString(url);
                        return true;
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
