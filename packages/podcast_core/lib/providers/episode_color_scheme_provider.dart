import 'package:flutter/material.dart';
import 'package:podcast_core/providers/audio_player_provider.dart';
import 'package:podcast_core/providers/color_scheme_from_remote_image_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'episode_color_scheme_provider.g.dart';

@riverpod
Future<ColorScheme?> currentPlayingEpisodeColorScheme(
  CurrentPlayingEpisodeColorSchemeRef ref,
  Brightness brightness,
) async {
  final episode = ref.watch(audioPlayerPodProvider).valueOrNull;
  if (episode case final episode?) {
    return ref
        .watch(
          colorSchemeFromRemoteImageProvider(
            episode.episode.imageUrl,
            brightness,
          ),
        )
        .valueOrNull;
  }
  return null;
}
