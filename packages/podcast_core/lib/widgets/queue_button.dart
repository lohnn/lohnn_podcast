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
    final queue = ref.watch(playlistPodProvider).valueOrNull ?? [];

    if (queue.contains(episode)) {
      return IconButton(
        tooltip: 'Remove from queue',
        onPressed: () {
          ref.read(playlistPodProvider.notifier).removeFromQueue(episode);
        },
        icon: const Icon(Icons.playlist_remove),
      );
    } else {
      return IconButton(
        tooltip: 'Add to queue',
        onPressed: () {
          ref.read(playlistPodProvider.notifier).addToBottomOfQueue(episode);
        },
        icon: const Icon(Icons.playlist_add),
      );
    }
  }
}
