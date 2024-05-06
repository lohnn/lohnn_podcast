import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/intents/play_pause_intent.dart';
import 'package:podcast/providers/audio_player_provider.dart';
import 'package:podcast/widgets/rounded_image.dart';

class SmallMediaPlayerControls extends ConsumerWidget {
  const SmallMediaPlayerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episode = ref.watch(audioPlayerPodProvider);
    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.space): ChangePlayStateIntent(
          PlayState.toggle,
        ),
      },
      child: SizedBox(
        height: 76,
        child: switch (episode) {
          null => const Center(child: Text('Nothing is playing')),
          final episode => Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RoundedImage(
                    imageUrl: episode.imageUrl,
                    imageSize: 60,
                  ),
                ),
                Expanded(child: Text(episode.title)),
                const PlayPauseButton(),
              ],
            )
        },
      ),
    );
  }
}

class PlayPauseButton extends ConsumerWidget {
  const PlayPauseButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlaying = ref.watch(audioPlayingProvider);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: switch (isPlaying) {
        AsyncData(:final value) => IconButton(
            onPressed: () {
              ref
                  .read(audioPlayerPodProvider.notifier)
                  .changePlayState(PlayState.toggle);
            },
            icon: Icon(
              switch (value) {
                false => Icons.play_arrow,
                true => Icons.pause,
              },
            ),
          ),
        _ => const CircularProgressIndicator.adaptive(),
      },
    );
  }
}
