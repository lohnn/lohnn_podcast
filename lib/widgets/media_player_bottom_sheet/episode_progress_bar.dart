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
    final currentPosition = ref.watch(currentPositionProvider);
    final bufferedPosition = ref.watch(bufferedPositionProvider);

    final colorScheme = ref.watch(episodeColorSchemeProvider(episode));

    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedContainer(
          key: const ValueKey('ProgressBar background'),
          duration: const Duration(milliseconds: 750),
          height: height,
          width: constraints.maxWidth,
          color: colorScheme.valueOrNull?.primary ?? Colors.grey,
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
      provider: NetworkImage(imageUrl),
    );
  }
  return null;
}
