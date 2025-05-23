import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
          _ExpansibleHtmlWidget(podcast: podcast),
        ],
      ),
    );
  }
}

class _ExpansibleHtmlWidget extends HookWidget {
  final _PodcastDetailsInformation podcast;

  const _ExpansibleHtmlWidget({required this.podcast});

  @override
  Widget build(BuildContext context) {
    // @TODO: If child is smaller than 100px, don't show it as expansible
    final isExpanded = useState(CrossFadeState.showFirst);

    return AnimatedCrossFade(
      crossFadeState: isExpanded.value,
      firstChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 100),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: HtmlWidget(podcast.description),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 24,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Theme.of(context).scaffoldBackgroundColor,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              isExpanded.value = CrossFadeState.showSecond;
            },
            child: Text(
              'Show more',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
      secondChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HtmlWidget(
            podcast.description,
            onTapUrl: (url) {
              launchUrlString(url);
              return true;
            },
          ),
          InkWell(
            onTap: () {
              isExpanded.value = CrossFadeState.showFirst;
            },
            child: Text(
              'Show less',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 300),
    );
  }
}

class _SubscribeChip extends ConsumerWidget {
  final PodcastRssUrl rssUrl;

  const _SubscribeChip(this.rssUrl);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    return switch (ref.watch(subscribedPodcastProvider(rssUrl: rssUrl)).value) {
      null => const Chip(label: Text('Loading...')),
      true => ActionChip(
        backgroundColor: colors.errorContainer,
        onPressed: () async {
          final shouldDelete = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
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
        label: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.remove_circle_outline, color: colors.onErrorContainer),
            const SizedBox(width: 8),
            Text(
              'Unsubscribe',
              style: TextStyle(color: colors.onErrorContainer),
            ),
          ],
        ),
      ),
      false => ActionChip(
        backgroundColor: colors.errorContainer,
        onPressed: () {
          ref.read(findPodcastProvider.notifier).subscribe(rssUrl);
        },
        label: Row(
          children: [
            Icon(Icons.add, color: colors.onErrorContainer),
            const SizedBox(width: 8),
            Text(
              'Add podcast',
              style: TextStyle(color: colors.onErrorContainer),
            ),
          ],
        ),
      ),
    };
  }
}
