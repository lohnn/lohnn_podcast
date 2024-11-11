import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/providers/episode_color_scheme_provider.dart';
import 'package:podcast/providers/firebase/firestore/episode_list_pod_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/widgets/play_episode_button.dart';
import 'package:podcast/widgets/pub_date_text.dart';
import 'package:podcast/widgets/rounded_image.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  EpisodeProvider get provider => episodeProvider(podcastId, episodeId);

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    (Podcast, DocumentSnapshot<Episode>) data,
  ) {
    final (podcast, episodeSnapshot) = data;
    final episode = episodeSnapshot.data();

    return Scaffold(
      appBar: AppBar(),
      body: episode == null
          ? Container()
          : AnimatedTheme(
              data: Theme.of(context).copyWith(
                colorScheme: ref
                    .watch(
                      episodeColorSchemeProvider(
                        episode,
                        Theme.of(context).brightness,
                      ),
                    )
                    .valueOrNull,
              ),
              key: const Key('EpisodeDetailsScreen.theme'),
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
                            imageUri: episode.imageUrl,
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
                      if (episode.pubDate case final pubDate?)
                        PubDateText(pubDate),
                      PlayEpisodeButton(episodeSnapshot),
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
    );
  }
}
