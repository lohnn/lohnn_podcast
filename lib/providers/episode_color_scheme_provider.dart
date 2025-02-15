import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcast/data/episode.model.dart';
import 'package:podcast/providers/audio_player_provider.dart';
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
        .watch(episodeColorSchemeProvider(episode.episode, brightness))
        .valueOrNull;
  }
  return null;
}

@riverpod
Future<ColorScheme?> episodeColorScheme(
  EpisodeColorSchemeRef ref,
  Episode episode,
  Brightness brightness,
) {
  return ColorScheme.fromImageProvider(
    provider: CachedNetworkImageProvider(episode.imageUrl.uri.toString()),
    brightness: brightness,
  );
}
