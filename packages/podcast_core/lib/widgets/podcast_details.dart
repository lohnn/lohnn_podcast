import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/data/podcast.model.dart';
import 'package:podcast_core/data/podcast_search.model.dart';
import 'package:podcast_core/providers/find_podcast_provider.dart';
import 'package:podcast_core/providers/podcasts_provider.dart';
import 'package:podcast_core/widgets/rounded_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class _PodcastDetailsInformation {
  final String title;
  final String description;
  final PodcastRssUrl url;
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
        url: podcast.url,
        artwork: podcast.artwork,
        link: podcast.url.url,
      ),
    );
  }

  factory PodcastDetails.fromList({Key? key, required Podcast podcast}) {
    return PodcastDetails._(
      key: key,
      podcast: _PodcastDetailsInformation(
        title: podcast.title,
        description: podcast.description,
        url: podcast.url,
        artwork: podcast.artwork,
        link: podcast.link,
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
                    // if (podcast.link case final link?)
                    //   InkWell(
                    //     child: Container(
                    //       width: double.infinity,
                    //       padding: const EdgeInsets.symmetric(vertical: 8),
                    //       child: Text(podcast.link.toString()),
                    //     ),
                    //     onTap: () => launchUrl(link),
                    //   ),
                    InkWell(
                      onTap: () => launchUrl(podcast.url.url),
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
          _SubscribeChip(podcast.url),
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
  final PodcastRssUrl rssUrl;

  const _SubscribeChip(this.rssUrl);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref
        .watch(subscribedPodcastProvider(rssUrl: rssUrl))
        .valueOrNull) {
      null => const Chip(label: Text('Loading...')),
      true => InputChip(
        onPressed: () async {
          final shouldDelete = await showDialog<bool>(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('Are you sure you want to unsubscribe?'),
                  actions: <Widget>[
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text('Yes'),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: const Text('No'),
                    ),
                  ],
                ),
          );
          if (shouldDelete != true) return;
          // Unsubscribe from the podcast
          await ref.read(findPodcastProvider.notifier).unsubscribe(rssUrl);
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
          ref.read(findPodcastProvider.notifier).subscribe(rssUrl);
        },
        label: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text('Add podcast'), SizedBox(width: 8), Icon(Icons.add)],
        ),
      ),
    };
  }
}
