import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/providers/audio_player_provider.dart';
import 'package:podcast/providers/podcasts_provider.dart';
import 'package:podcast/widgets/plasma_sphere_widget.dart';
import 'package:podcast/widgets/pub_date_text.dart';
import 'package:podcast/widgets/rounded_image.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CurrentlyPlayingInformation extends ConsumerWidget {
  const CurrentlyPlayingInformation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodeSnapshot = ref.watch(audioPlayerPodProvider);
    final episode = episodeSnapshot.valueOrNull?.episode;
    if (episode == null) {
      return const Center(child: ParticleLoading());
    }

    final podcast =
        ref.watch(podcastPodProvider(episode.podcastId)).valueOrNull;
    if (podcast == null) {
      return const Center(child: ParticleLoading());
    }

    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Currently playing:', style: textTheme.titleLarge),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight,
                  child: CarouselView.weighted(
                    itemSnapping: true,
                    flexWeights: const [1, 7, 1],
                    children: [
                      _CarouselInformation(
                        constraints: constraints,
                        image: podcast.imageUrl.uri,
                        content: [
                          Text(podcast.name, style: textTheme.titleMedium),
                          HtmlWidget(
                            podcast.description,
                            onTapUrl: (url) {
                              launchUrlString(url);
                              return true;
                            },
                          ),
                        ],
                      ),
                      _CarouselInformation(
                        constraints: constraints,
                        image: episode.imageUrl.uri,
                        content: [
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

class _CarouselInformation extends StatelessWidget {
  final Uri image;
  final List<Widget> content;
  final BoxConstraints constraints;

  const _CarouselInformation({
    required this.image,
    required this.content,
    required this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: OverflowBox(
        maxWidth: constraints.maxWidth * 7 / 8,
        minWidth: constraints.maxWidth * 7 / 8,
        child: Column(
          spacing: 8,
          children: [
            RoundedImage(imageUri: image, fit: BoxFit.cover),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth * 1 / 10,
              ),
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: content,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
