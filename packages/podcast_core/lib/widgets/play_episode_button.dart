import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/providers/audio_player_provider.dart';

class PlayEpisodeButton extends ConsumerWidget {
  final Episode episode;

  const PlayEpisodeButton(this.episode, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: 'Play ${episode.title}',
      onPressed: () {
        ref.read(audioPlayerPodProvider.notifier).playEpisode(episode);
      },
      icon: const Icon(Icons.play_arrow),
    );
  }
}
