import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/intents/actions/play_pause_action.dart';
import 'package:podcast/intents/play_pause_intent.dart';
import 'package:podcast/providers/audio_player_provider.dart';

class PodcastActions extends ConsumerWidget {
  final Widget child;

  const PodcastActions({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Actions(
      actions: {
        ChangePlayStateIntent: ChangePlayStateAction(
          ref.watch(audioPlayerPodProvider.notifier),
        ),
      },
      child: child,
    );
  }
}
