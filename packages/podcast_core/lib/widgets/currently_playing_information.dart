import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/providers/playlist_pod_provider.dart';
import 'package:podcast_core/providers/podcasts_provider.dart';
import 'package:podcast_core/widgets/plasma_sphere_widget.dart';
import 'package:podcast_core/widgets/pub_date_text.dart';
import 'package:podcast_core/widgets/rounded_image.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CurrentlyPlayingInformation extends ConsumerWidget {
  final void Function(String path) onNavigate;

  const CurrentlyPlayingInformation({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(playlistPodProvider).valueOrNull;

    if (queue == null) {
      return const Center(child: ParticleLoading());
    }

    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Show playlist',
                onPressed: () => onNavigate('/playlist'),
                icon: Icon(
                  Icons.playlist_play,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Text('In your queue:', style: textTheme.titleLarge),
            ],
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight,
                  child: CarouselView.weighted(
                    scrollDirection: Axis.vertical,
                    itemSnapping: true,
                    onTap: (index) async {
                      final podcast = await ref.read(
                        podcastPodProvider(queue[index].podcastId).future,
                      );

                      if (!context.mounted) return;
                      onNavigate('/${podcast.id}/${queue[index].id}');
                    },
                    flexWeights: [
                      1,
                      7,
                      1,
                      for (final _ in constraints.maxHeight.inIncrements(
                        start: 800,
                        step: 200,
                      ))
                        1,
                    ],
                    children: [
                      for (final (index, episode) in queue.indexed)
                        _CarouselInformation(
                          key: ValueKey(episode),
                          constraints: constraints,
                          index: index,
                          episode: episode,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CarouselInformation extends ConsumerWidget {
  final Episode episode;
  final int index;
  final BoxConstraints constraints;

  const _CarouselInformation({
    super.key,
    required this.episode,
    required this.index,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final podcast =
        ref.watch(podcastPodProvider(episode.podcastId)).valueOrNull;

    final textTheme = Theme.of(context).textTheme;
    return OverflowBox(
      alignment: Alignment.topLeft,
      minHeight: 0,
      maxHeight: double.infinity,
      child: Column(
        spacing: 8,
        children: [
          RoundedImage(
            radius: 28,
            imageUri: episode.imageUrl,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(podcast?.title ?? '', style: textTheme.titleMedium),
                Text(episode.title, style: textTheme.titleMedium),
                if (episode.pubDate case final pubDate?)
                  DefaultTextStyle(
                    style: textTheme.labelSmall!,
                    child: PubDateText(pubDate),
                  ),
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
        ],
      ),
    );
  }
}

extension on double {
  /// Generates a sequence of doubles starting from [start] to [this] (exclusive)
  /// with a step of [step].
  Iterable<double> inIncrements({
    required double start,
    required double step,
  }) sync* {
    for (var i = start; i < this; i += step) {
      yield i;
    }
  }
}
