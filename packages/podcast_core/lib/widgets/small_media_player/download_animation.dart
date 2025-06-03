import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/providers/episode_loader_provider.dart';
import 'package:podcast_core/widgets/rive/podcast_animation.dart';

class DownloadAnimation extends HookConsumerWidget {
  const DownloadAnimation({super.key, required this.episode});

  final Episode episode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(
      episodeLoaderProvider(
        episode,
      ).select((e) => e.value?.currentDownloadProgress),
    );

    return PodcastAnimation(
      artboard: PodcastAnimationArtboard.download,
      params: {'Progress': progress},
    );
  }
}
