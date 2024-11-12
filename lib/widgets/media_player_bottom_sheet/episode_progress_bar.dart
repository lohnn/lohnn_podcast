import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/episode.model.dart';
import 'package:podcast/providers/audio_player_provider.dart';

class EpisodeProgressBar extends ConsumerWidget {
  final Episode episode;
  final double height;

  const EpisodeProgressBar(this.episode, {required this.height, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final durations = ref.watch(currentPositionProvider).valueOrNull;

    final colorScheme = Theme.of(context).colorScheme;

    final episodeDuration = durations?.duration ?? episode.duration?.duration;

    final bufferProgress = switch ((durations?.buffered, episodeDuration)) {
      (final bufferPosition?, final episodeDuration?) =>
        bufferPosition.inMicroseconds / episodeDuration.inMicroseconds,
      _ => null,
    };

    final progress = switch ((durations?.position, episodeDuration)) {
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
                  color: colorScheme.primaryContainer,
                ),
              ),
            if (progress case final progress?)
              Positioned(
                child: AnimatedContainer(
                  key: const ValueKey('ProgressBar background'),
                  duration: const Duration(milliseconds: 300),
                  height: height,
                  width: constraints.maxWidth * progress,
                  color: colorScheme.primary,
                ),
              ),
          ],
        );
      },
    );
  }
}
