import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:podcast/data/podcast.model.dart';
import 'package:podcast/data/podcast_search.model.dart';
import 'package:podcast/widgets/rounded_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class _PodcastDetailsInformation {
  final String title;
  final String description;
  final Uri url;
  final Uri artwork;

  const _PodcastDetailsInformation({
    required this.title,
    required this.description,
    required this.url,
    required this.artwork,
  });
}

class PodcastDetails extends StatelessWidget {
  final _PodcastDetailsInformation podcast;

  const PodcastDetails._({super.key, required this.podcast});

  factory PodcastDetails.fromSearch({
    Key? key,
    required PodcastSearch podcast,
  }) {
    return PodcastDetails._(
      key: key,
      podcast: _PodcastDetailsInformation(
        title: podcast.title,
        description: podcast.description,
        url: podcast.url.uri,
        artwork: podcast.artwork.uri,
      ),
    );
  }

  factory PodcastDetails.fromList({Key? key, required Podcast podcast}) {
    return PodcastDetails._(
      key: key,
      podcast: _PodcastDetailsInformation(
        title: podcast.name,
        description: podcast.description,
        url: podcast.rssUri,
        artwork: podcast.imageUrl.uri,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoundedImage(imageUri: podcast.artwork, imageSize: 100),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    podcast.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // InkWell(
                  //   child: Container(
                  //     width: double.infinity,
                  //     padding: const EdgeInsets.symmetric(vertical: 8),
                  //     child: Text(podcast.link),
                  //   ),
                  //   onTap: () => launchUrlString(podcast.link),
                  // ),
                  InkWell(
                    onTap: () => launchUrl(podcast.url),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [Text('Rss feed'), Icon(Icons.rss_feed)],
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
    );
  }
}
