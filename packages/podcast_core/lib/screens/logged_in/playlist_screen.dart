import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/providers/playlist_pod_provider.dart';
import 'package:podcast_core/providers/user_episode_status_provider.dart';
import 'package:podcast_core/screens/async_value_screen.dart';
import 'package:podcast_core/widgets/episode_list_item.dart';

class PlaylistScreen extends AsyncValueWidget<List<Episode>> {
  const PlaylistScreen({super.key});

  @override
  ProviderBase<AsyncValue<List<Episode>>> get provider => playlistPodProvider;

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    List<Episode> data,
  ) {
    final episodesStatus = ref.watch(userEpisodeStatusPodProvider).value;

    return Scaffold(
      appBar: AppBar(),
      body: ReorderableListView.builder(
        onReorder: (oldIndex, newIndex) {
          ref.read(playlistPodProvider.notifier).reorder(oldIndex, newIndex);
        },
        itemCount: data.length,
        itemBuilder: (context, index) {
          final episode = data[index];

          return EpisodeListItem(
            key: ValueKey(episode),
            isPlayed: episodesStatus?[episode.id]?.isPlayed ?? false,
            episodeWithStatus: episode,
            trailing: const SizedBox(width: 24),
          );
        },
      ),
    );
  }
}
