import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/providers/audio_player_provider.dart';
import 'package:podcast/providers/episode_color_scheme_provider.dart';
import 'package:podcast/widgets/media_player_bottom_sheet/media_action_button.dart';
import 'package:podcast/widgets/media_player_bottom_sheet/play_pause_button.dart';
import 'package:podcast/widgets/rounded_image.dart';

class EpisodePlayerModal extends HookConsumerWidget {
  const EpisodePlayerModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episode = ref.watch(audioPlayerPodProvider).valueOrNull;
    final currentPosition =
        ref.watch(currentPositionProvider).valueOrNull?.position;

    useEffect(
      () {
        if (episode == null) Navigator.pop(context);
        return null;
      },
      [episode],
    );

    if (episode == null) return Container();

    final colorScheme =
        ref.watch(episodeColorSchemeProvider(episode)).valueOrNull;

    final episodeDuration = episode.duration ??
        ref.watch(audioPlayerPodProvider.notifier).currentEpisodeDuration;

    return AnimatedTheme(
      key: const ValueKey('EpisodePlayerModal.theme'),
      duration: const Duration(milliseconds: 750),
      data: ThemeData(colorScheme: colorScheme),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RoundedImage(imageUri: episode.imageUrl),
              Text(episode.title),
              if ((currentPosition, episodeDuration)
                  case (final currentPosition?, final episodeDuration?))
                Slider.adaptive(
                  value: currentPosition.inMilliseconds.toDouble(),
                  max: episodeDuration.inMilliseconds.toDouble(),
                  onChanged: (value) {
                    ref
                        .read(audioPlayerPodProvider.notifier)
                        .setPosition(value.toInt());
                  },
                ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MediaActionButton(
                    action: MediaAction.rewind,
                    icon: Icons.replay_10,
                  ),
                  PlayPauseButton(),
                  MediaActionButton(
                    action: MediaAction.fastForward,
                    icon: Icons.forward_10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
