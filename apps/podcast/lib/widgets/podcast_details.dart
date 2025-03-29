import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/podcast.model.dart';
import 'package:podcast/data/podcast_search.model.dart';
import 'package:podcast/providers/find_podcast_provider.dart';
import 'package:podcast/providers/podcasts_provider.dart';
import 'package:podcast/widgets/rounded_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class _PodcastDetailsInformation {
  final String title;
  final String description;
  final Uri url;
  final Uri artwork;
  final Uri link;

  const _PodcastDetailsInformation({
    required this.title,
    required this.description,
    required this.url,
    required this.artwork,
    required this.link,
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
        link: podcast.url.uri,
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
        link: Uri.parse(podcast.link),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SelectableRegion(
      selectionControls: materialTextSelectionControls,
      child: Column(
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
                    InkWell(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(podcast.link.toString()),
                      ),
                      onTap: () => launchUrl(podcast.link),
                    ),
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
          _SubscribeChip(podcast),
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
    );
  }
}

class _SubscribeChip extends ConsumerWidget {
  final _PodcastDetailsInformation podcast;

  const _SubscribeChip(this.podcast);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref
        .watch(subscribedPodcastProvider(rssUrl: podcast.url.toString()))
        .valueOrNull) {
      null => const Chip(label: Text('Loading...')),
      true => InputChip(
        onPressed: () {
          ref
              .read(findPodcastProvider.notifier)
              .unsubscribe(podcast.url.toString());
        },
        label: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Remove podcast'),
            SizedBox(width: 8),
            Icon(Icons.remove),
          ],
        ),
      ),
      false => InputChip(
        onPressed: () {
          ref
              .read(findPodcastProvider.notifier)
              .subscribe(podcast.url.toString());
        },
        label: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text('Add podcast'), SizedBox(width: 8), Icon(Icons.add)],
        ),
      ),
    };
  }
}
