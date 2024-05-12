import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/providers/audio_player_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'episode_progress_bar.g.dart';

class EpisodeProgressBar extends ConsumerWidget {
  final Episode episode;
  final double height;

  const EpisodeProgressBar(this.episode, {required this.height, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioStateProvider).valueOrNull;

    final colorScheme = Theme.of(context).colorScheme;

    final episodeDuration = episode.duration ??
        ref.watch(audioPlayerPodProvider.notifier).currentEpisodeDuration;

    final bufferProgress =
        switch ((audioState?.bufferedPosition, episodeDuration)) {
      (final bufferPosition?, final episodeDuration?) =>
        bufferPosition.inMicroseconds / episodeDuration.inMicroseconds,
      _ => null,
    };

    final progress = switch ((audioState?.position, episodeDuration)) {
      (final currentPosition?, final episodeDuration?) =>
        currentPosition.inMicroseconds / episodeDuration.inMicroseconds,
      _ => null,
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            AnimatedContainer(
              key: const ValueKey('ProgressBar background'),
              duration: const Duration(milliseconds: 750),
              height: height,
              width: constraints.maxWidth,
              color: Colors.grey,
            ),
            if (bufferProgress case final bufferProgress?)
              Positioned(
                child: AnimatedContainer(
                  key: const ValueKey('ProgressBar background'),
                  duration: const Duration(milliseconds: 300),
                  height: height,
                  width: constraints.maxWidth * bufferProgress,
                  color: colorScheme.primary,
                ),
              ),
            if (progress case final progress?)
              Positioned(
                child: AnimatedContainer(
                  key: const ValueKey('ProgressBar background'),
                  duration: const Duration(milliseconds: 300),
                  height: height,
                  width: constraints.maxWidth * progress,
                  color: colorScheme.primaryContainer,
                ),
              ),
          ],
        );
      },
    );
  }
}

@riverpod
Future<ColorScheme?> episodeColorScheme(
  EpisodeColorSchemeRef ref,
  Episode episode,
) async {
  // @TODO: Fallback to podcast image
  if (episode.imageUrl case final imageUrl?) {
    return ColorScheme.fromImageProvider(
      provider: CachedNetworkImageProvider(imageUrl.toString()),
    );
  }
  return null;
}
