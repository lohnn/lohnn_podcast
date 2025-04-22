import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcast_core/helpers/platform_helpers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'color_scheme_from_remote_image_provider.g.dart';

@riverpod
Future<ColorScheme?> colorSchemeFromRemoteImage(
  ColorSchemeFromRemoteImageRef ref,
  Uri imageUri,
  Brightness brightness,
) {
  if (isWeb) {
    return ColorScheme.fromImageProvider(
      provider: NetworkImage(
        imageUri.toString(),
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
      ),
      brightness: brightness,
    );
  }

  return ColorScheme.fromImageProvider(
    provider: CachedNetworkImageProvider(imageUri.toString()),
    brightness: brightness,
  );
}
