import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcast/data/episode.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'episode_color_scheme_provider.g.dart';

@riverpod
Future<ColorScheme?> episodeColorScheme(
  EpisodeColorSchemeRef ref,
  Episode episode,
) {
  return ColorScheme.fromImageProvider(
    provider: CachedNetworkImageProvider(episode.imageUrl.toString()),
  );
}
