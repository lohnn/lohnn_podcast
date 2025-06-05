import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/providers/playlist_pod_provider.dart';

class QueueButton extends ConsumerWidget {
  final Episode episode;

  const QueueButton({super.key, required this.episode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // @TODO: Verify why provider is rebuilding multiple times
    final queue = ref.watch(playlistPodProvider).value ?? [];

    final onPressed = switch (queue.contains(episode)) {
      true => () {
        ref.read(playlistPodProvider.notifier).removeFromQueue(episode);
      },
      false => () {
        ref.read(playlistPodProvider.notifier).addToBottomOfQueue(episode);
      },
    };

    final icon = switch (queue.contains(episode)) {
      true => const Icon(Icons.playlist_remove, key: Key('Remove icon')),
      false => const Icon(Icons.playlist_add, key: Key('Add icon')),
    };

    final tooltip = switch (queue.contains(episode)) {
      true => 'Remove from queue',
      false => 'Add to queue',
    };

    return Tooltip(
      message: tooltip,
      child: FilledButton.tonal(
        onPressed: onPressed,
        child: Semantics(
          label: tooltip,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: icon,
          ),
        ),
      ),
    );
  }
}
