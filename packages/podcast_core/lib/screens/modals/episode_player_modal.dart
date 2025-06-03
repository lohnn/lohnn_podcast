import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/extensions/duration_extensions.dart';
import 'package:podcast_core/providers/audio_player_provider.dart';
import 'package:podcast_core/widgets/media_player_bottom_sheet/media_action_button.dart';
import 'package:podcast_core/widgets/media_player_bottom_sheet/play_pause_button.dart';
import 'package:podcast_core/widgets/media_player_bottom_sheet/show_playlist_button.dart';
import 'package:podcast_core/widgets/rounded_image.dart';

enum EpisodePlayerModalResultAction { showPlaylist }

class EpisodePlayerModal extends HookConsumerWidget {
  const EpisodePlayerModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episode = ref.watch(audioPlayerPodProvider).value?.episode;
    final durations = ref.watch(currentPositionProvider).value;

    useEffect(() {
      if (episode == null) Navigator.pop(context);
      return null;
    }, [episode]);

    if (episode == null) return Container();

    final episodeDuration = durations?.duration ?? episode.duration;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.35),
            Colors.transparent,
          ],
          center: Alignment.bottomCenter,
        ),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // AspectRatio(aspectRatio: 1),
              RoundedImage(imageUri: episode.imageUrl),
              Text(episode.title),
              if ((durations?.position, episodeDuration) case (
                final currentPosition?,
                final episodeDuration?,
              )) ...[
                Slider(
                  value: min(
                    currentPosition.inMilliseconds.toDouble(),
                    episodeDuration.inMilliseconds.toDouble(),
                  ),
                  max: episodeDuration.inMilliseconds.toDouble(),
                  onChanged: (value) {
                    ref
                        .read(audioPlayerPodProvider.notifier)
                        .setPosition(value.toInt());
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(currentPosition.prettyPrint()),
                    Text((currentPosition - episodeDuration).prettyPrint()),
                  ],
                ),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ShowPlaylistButton(),
                  MediaActionButton.back(),
                  const PlayPauseButton(),
                  MediaActionButton.forward(),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
