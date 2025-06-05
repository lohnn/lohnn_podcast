import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:podcast_core/helpers/platform_helpers.dart';

class PotentiallyCachedImage extends StatelessWidget {
  final String uri;
  final double? width;
  final double? height;
  final int? cachedWidth;
  final int? cachedHeight;
  final BoxFit? fit;
  final String semanticLabel;

  const PotentiallyCachedImage(
    this.uri, {
    required this.semanticLabel,
    super.key,
    this.width,
    this.height,
    this.cachedWidth,
    this.cachedHeight,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    if (isWeb || isRunningTest) {
      return Image.network(
        semanticLabel: semanticLabel,
        uri,
        width: width,
        height: height,
        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
        fit: fit,
      );
    }
    return Semantics(
      label: semanticLabel,
      image: true,
      excludeSemantics: true,
      child: CachedNetworkImage(
        imageUrl: uri,
        width: width,
        height: height,
        memCacheWidth: cachedWidth,
        memCacheHeight: cachedHeight,
        fit: fit,
      ),
    );
  }
}
