import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/providers/audio_player_provider.dart';
import 'package:podcast_core/widgets/rive/podcast_animation.dart';
import 'package:podcast_core/widgets/rive/podcast_animation_config.dart';

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
            tooltip: switch (playing) {
              false => 'Play',
              true => 'Pause',
            },
            onPressed: () {
              HapticFeedback.lightImpact();
              ref
                  .read(audioPlayerPodProvider.notifier)
                  .triggerMediaAction(MediaAction.playPause);
            },
            icon: PodcastAnimation(
              animationArtboard: PodcastAnimationConfig.playPause(
                isPlaying: playing,
              ),
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
