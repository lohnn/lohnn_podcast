import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/providers/audio_player_provider.dart';

class PlayPauseButton extends ConsumerWidget {
  const PlayPauseButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioStateProvider);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: switch (audioState) {
        AsyncData(value: PlaybackState(:final playing, :final processingState))
            when processingState != AudioProcessingState.loading ||
                processingState != AudioProcessingState.buffering =>
          IconButton(
            onPressed: () {
              ref
                  .read(audioPlayerPodProvider.notifier)
                  .triggerMediaAction(MediaAction.playPause);
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
