import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/episode_with_status.dart';
import 'package:podcast/intents/play_pause_intent.dart';
import 'package:podcast/providers/audio_player_provider.dart';
import 'package:podcast/screens/modals/episode_player_modal.dart';
import 'package:podcast/widgets/media_player_bottom_sheet/episode_progress_bar.dart';
import 'package:podcast/widgets/media_player_bottom_sheet/play_pause_button.dart';
import 'package:podcast/widgets/rounded_image.dart';

class SmallMediaPlayerControls extends ConsumerWidget {
  final GoRouter router;

  const SmallMediaPlayerControls({
    super.key,
    required this.router,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodeSnapshot = ref.watch(audioPlayerPodProvider);

    return Shortcuts(
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
              null => const Center(
                  child: Text('Nothing is playing right now'),
                ),
              EpisodeWithStatus(:final episode) => InkWell(
                  onTap: () async {
                    final action = await showModalBottomSheet<
                        EpisodePlayerModalResultAction>(
                      context: context,
                      isScrollControlled: true,
                      useSafeArea: true,
                      showDragHandle: true,
                      builder: (context) => const EpisodePlayerModal(),
                    );

                    switch (action) {
                      case EpisodePlayerModalResultAction.showPlaylist:
                        if (context.mounted) {
                          router.push('/playlist');
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
                                imageUri: episode.imageUrl.uri,
                                imageSize: 60,
                              ),
                            ),
                            Expanded(child: Text(episode.title)),
                            const PlayPauseButton(),
                          ],
                        ),
                      ),
                      EpisodeProgressBar(
                        episode,
                        height: 4,
                      ),
                    ],
                  ),
                )
            },
          AsyncValue<EpisodeWithStatus?>() => throw UnimplementedError(
              'This should not be a case, AsyncValue is just not sealed',
            ),
        },
      ),
    );
  }
}
