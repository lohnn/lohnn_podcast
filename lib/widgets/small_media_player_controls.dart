import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/providers/firebase/audio_player_provider.dart';
import 'package:podcast/widgets/rounded_image.dart';

class SmallMediaPlayerControls extends ConsumerWidget {
  const SmallMediaPlayerControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episode = ref.watch(audioPlayerPodProvider);
    return SizedBox(
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
              switch (isPlaying) {
                case AsyncData(value: true):
                  ref.read(audioPlayerPodProvider.notifier).pause();
                case AsyncData(value: false):
                  ref.read(audioPlayerPodProvider.notifier).resume();
              }
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
