import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/providers/audio_player_provider.dart';

class MediaActionButton extends ConsumerWidget {
  final MediaAction action;
  final IconData icon;

  const MediaActionButton({
    required this.icon,
    required this.action,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return IconButton(
      onPressed: () {
        ref.read(audioPlayerPodProvider.notifier).triggerMediaAction(action);
      },
      icon: Icon(icon, color: theme.colorScheme.primary),
    );
  }
}
