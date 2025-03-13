import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/podcast.model.dart';
import 'package:podcast/providers/color_scheme_from_remote_image_provider.dart';
import 'package:podcast/widgets/rounded_image.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PodcastDetailsModal extends ConsumerWidget {
  final Podcast podcast;

  const PodcastDetailsModal({super.key, required this.podcast});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedTheme(
      data: Theme.of(context).copyWith(
        colorScheme:
            ref
                .watch(
                  colorSchemeFromRemoteImageProvider(
                    podcast.imageUrl,
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
                  RoundedImage(imageUri: podcast.imageUrl.uri, imageSize: 100),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          podcast.name,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(podcast.link),
                          ),
                          onTap: () => launchUrlString(podcast.link),
                        ),
                        InkWell(
                          onTap: () => launchUrlString(podcast.rssUrl),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                Text('Rss feed'),
                                Icon(Icons.rss_feed),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              HtmlWidget(
                podcast.description,
                onTapUrl: (url) {
                  launchUrlString(url);
                  return true;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
