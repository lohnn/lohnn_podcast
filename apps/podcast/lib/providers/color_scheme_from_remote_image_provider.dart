import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcast/data/serdes/uri_model.dart';
import 'package:podcast/helpers/platform_helpers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'color_scheme_from_remote_image_provider.g.dart';

@riverpod
Future<ColorScheme?> colorSchemeFromRemoteImage(
  ColorSchemeFromRemoteImageRef ref,
  UriModel uriModel,
  Brightness brightness,
) {
  if (isWeb) {
    return ColorScheme.fromImageProvider(
      provider: NetworkImage(
        uriModel.uri.toString(),
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
      ),
      brightness: brightness,
    );
  }

  return ColorScheme.fromImageProvider(
    provider: CachedNetworkImageProvider(uriModel.uri.toString()),
    brightness: brightness,
  );
}
