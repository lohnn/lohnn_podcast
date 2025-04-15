import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/providers/audio_player_provider.dart';
import 'package:podcast/widgets/long_press_swipe_menu.dart';

class MediaActionButton extends HookConsumerWidget {
  final MediaAction action;
  final IconData icon;
  final String tooltip;
  final List<SwipeOption<Duration>> options;

  const MediaActionButton({
    required this.icon,
    required this.action,
    required this.tooltip,
    required this.options,
    super.key,
  });

  factory MediaActionButton.back() {
    return MediaActionButton(
      action: MediaAction.rewind,
      icon: Icons.replay_10,
      tooltip: 'Rewind 10 seconds',
      options: [
        SwipeOption(
          icon: Icons.replay_5,
          value: const Duration(seconds: -5),
          tooltip: 'Rewind 5 seconds',
        ),
        SwipeOption(
          icon: Icons.replay_30,
          tooltip: 'Rewind 30 seconds',
          value: const Duration(seconds: -30),
        ),
      ],
    );
  }

  factory MediaActionButton.forward() {
    return MediaActionButton(
      action: MediaAction.fastForward,
      icon: Icons.forward_10,
      tooltip: 'Skip forward 10 seconds',
      options: [
        SwipeOption(
          icon: Icons.forward_5,
          value: const Duration(seconds: 5),
          tooltip: 'Forward 5 seconds',
        ),
        SwipeOption(
          icon: Icons.forward_30,
          tooltip: 'Forward 30 seconds',
          value: const Duration(seconds: 30),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positionKey = useMemoized(GlobalKey.new);
    return LongPressSwipeMenu<Duration>(
      key: positionKey,
      options: options,
      onOptionPressed: (duration) {
        ref.read(audioPlayerPodProvider.notifier).seekRelative(duration);
      },
      onPressed: () {
        ref.read(audioPlayerPodProvider.notifier).triggerMediaAction(action);
      },
      initialIcon: icon,
      tooltip: tooltip,
    );
  }
}
