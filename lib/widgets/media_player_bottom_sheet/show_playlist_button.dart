import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ShowPlaylistButton extends ConsumerWidget {
  const ShowPlaylistButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return IconButton(
      onPressed: () {
        // ref.read(audioPlayerPodProvider.notifier).triggerMediaAction(action);
      },
      icon: Icon(
        Icons.playlist_play,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
