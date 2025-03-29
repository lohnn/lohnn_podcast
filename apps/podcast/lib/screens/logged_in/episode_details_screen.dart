import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/episode_with_status.dart';
import 'package:podcast/data/podcast.model.dart';
import 'package:podcast/providers/color_scheme_from_remote_image_provider.dart';
import 'package:podcast/providers/episodes_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/widgets/play_episode_button.dart';
import 'package:podcast/widgets/pub_date_text.dart';
import 'package:podcast/widgets/rounded_image.dart';
import 'package:url_launcher/url_launcher_string.dart';

class EpisodeDetailsScreen
    extends AsyncValueWidget<(Podcast, EpisodeWithStatus)> {
  final String podcastId;
  final String episodeId;

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
          colorScheme:
              ref
                  .watch(
                    ColorSchemeFromRemoteImageProvider(
                      episode.imageUrl,
                      Theme.of(context).brightness,
                    ),
                  )
                  .valueOrNull,
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
                      RoundedImage(
                        imageUri: episode.imageUrl.uri,
                        imageSize: 76,
                      ),
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
                  if (episode.pubDate case final pubDate?) PubDateText(pubDate),
                  PlayEpisodeButton(episode),
                  if (episode.description case final description?)
                    HtmlWidget(
                      description,
                      onTapUrl: (url) {
                        launchUrlString(url);
                        return true;
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
