import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/providers/audio_player_provider.dart';
import 'package:podcast/widgets/media_player_bottom_sheet/media_action_button.dart';
import 'package:podcast/widgets/media_player_bottom_sheet/play_pause_button.dart';
import 'package:podcast/widgets/media_player_bottom_sheet/show_playlist_button.dart';
import 'package:podcast/widgets/rounded_image.dart';

enum EpisodePlayerModalResultAction { showPlaylist }

class EpisodePlayerModal extends HookConsumerWidget {
  const EpisodePlayerModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episode = ref.watch(audioPlayerPodProvider).valueOrNull?.episode;
    final durations = ref.watch(currentPositionProvider).valueOrNull;

    useEffect(() {
      if (episode == null) Navigator.pop(context);
      return null;
    }, [episode]);

    if (episode == null) return Container();

    final episodeDuration = durations?.duration ?? episode.duration?.duration;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RoundedImage(imageUri: episode.imageUrl.uri),
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShowPlaylistButton(),
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
    );
  }
}

extension on Duration {
  String prettyPrint() {
    // final negativeSign = isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(inMinutes.remainder(60).abs());
    final twoDigitSeconds = twoDigits(inSeconds.remainder(60).abs());
    return '${twoDigits(inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}
