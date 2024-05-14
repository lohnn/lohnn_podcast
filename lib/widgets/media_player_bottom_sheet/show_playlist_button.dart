import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/screens/modals/episode_player_modal.dart';

class ShowPlaylistButton extends ConsumerWidget {
  const ShowPlaylistButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return IconButton(
      onPressed: () {
        Navigator.of(context).pop(EpisodePlayerModalResultAction.showPlaylist);
      },
      icon: Icon(
        Icons.playlist_play,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
