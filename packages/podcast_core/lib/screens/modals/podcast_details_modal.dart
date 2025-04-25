import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/data/podcast.model.dart';
import 'package:podcast_core/providers/color_scheme_from_remote_image_provider.dart';
import 'package:podcast_core/widgets/podcast_details.dart';

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
                    podcast.artwork,
                    Theme.of(context).brightness,
                  ),
                )
                .valueOrNull,
      ),
      key: const Key('EpisodeDetailsScreen.theme'),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: PodcastDetails.fromSearch(podcast: podcast),
        ),
      ),
    );
  }
}
