import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast/intents/play_pause_intent.dart';
import 'package:podcast/providers/audio_player_provider.dart';

class PlayPauseButton extends ConsumerWidget {
  const PlayPauseButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlaying = ref.watch(audioStateProvider);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: switch (isPlaying) {
        AsyncData(value: PlayerState(:final playing, :final processingState))
            when processingState == ProcessingState.ready =>
          IconButton(
            onPressed: () {
              ref
                  .read(audioPlayerPodProvider.notifier)
                  .changePlayState(PlayState.toggle);
            },
            icon: Icon(
              switch (playing) {
                false => Icons.play_arrow,
                true => Icons.pause,
              },
              color: theme.colorScheme.primary,
            ),
          ),
        _ => IconButton(
            onPressed: null,
            icon: SizedBox(
              width: theme.iconTheme.size ?? kDefaultFontSize,
              height: theme.iconTheme.size ?? kDefaultFontSize,
              child: const CircularProgressIndicator.adaptive(),
            ),
          ),
      },
    );
  }
}
