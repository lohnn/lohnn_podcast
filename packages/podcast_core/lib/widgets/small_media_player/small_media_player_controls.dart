import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/data/episode_with_status.dart';
import 'package:podcast_core/intents/play_pause_intent.dart';
import 'package:podcast_core/providers/audio_player_provider.dart';
import 'package:podcast_core/screens/modals/episode_player_modal.dart';
import 'package:podcast_core/widgets/rounded_image.dart';
import 'package:podcast_core/widgets/small_media_player/download_animation.dart';
import 'package:podcast_core/widgets/small_media_player/episode_progress_bar.dart';
import 'package:podcast_core/widgets/small_media_player/media_action_button.dart';
import 'package:podcast_core/widgets/small_media_player/play_pause_button.dart';

class SmallMediaPlayerControls extends HookConsumerWidget {
  final GoRouter router;
  final bool showSkipButtons;

  const SmallMediaPlayerControls({
    super.key,
    required this.router,
    this.showSkipButtons = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodeSnapshot = ref.watch(audioPlayerPodProvider);

    return Material(
      child: Shortcuts(
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.space): ChangePlayStateIntent(
            MediaAction.playPause,
          ),
        },
        child: SizedBox(
          height: 85,
          child: switch (episodeSnapshot) {
            AsyncLoading() => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            AsyncError() => const Center(child: Text('Error loading episode')),
            AsyncData(value: final episode) => switch (episode) {
              null => const Center(child: Text('Nothing is playing right now')),
              EpisodeWithStatus(:final episode) => InkWell(
                onTap: () async {
                  final action =
                      await showModalBottomSheet<
                        EpisodePlayerModalResultAction
                      >(
                        context: context,
                        isScrollControlled: true,
                        useSafeArea: true,
                        showDragHandle: true,
                        builder: (context) => const EpisodePlayerModal(),
                      );

                  switch (action) {
                    case EpisodePlayerModalResultAction.showPlaylist:
                      if (context.mounted) {
                        unawaited(router.push('/playlist'));
                      }
                    case null:
                  }
                },
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RoundedImage(
                              semanticLabel: 'Episode image',
                              imageUri: episode.imageUrl,
                              imageSize: 60,
                            ),
                          ),
                          // @TODO: Add download animation when supported again
                          // if (episodeSnapshot.value case final episodeSnapshot?)
                          //   SizedBox(
                          //     width: 36,
                          //     child: DownloadAnimation(
                          //       episode: episodeSnapshot.episode,
                          //     ),
                          //   ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(episode.title)),
                          if (showSkipButtons) MediaActionButton.back(),
                          const PlayPauseButton(),
                          if (showSkipButtons) MediaActionButton.forward(),
                        ],
                      ),
                    ),
                    EpisodeProgressBar(episode, height: 4),
                  ],
                ),
              ),
            },
          },
        ),
      ),
    );
  }
}
