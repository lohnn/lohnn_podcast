import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/screens/playlist_screen.dart';

class ShowPlaylistButton extends ConsumerWidget {
  const ShowPlaylistButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return IconButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const PlaylistScreen()),
        );
      },
      icon: Icon(
        Icons.playlist_play,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
