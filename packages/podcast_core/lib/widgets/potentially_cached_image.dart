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

  const PotentiallyCachedImage(
    this.uri, {
    super.key,
    this.width,
    this.height,
    this.cachedWidth,
    this.cachedHeight,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    if (isWeb) {
      return Image.network(
        uri,
        width: width,
        height: height,
        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
        fit: fit,
      );
    }
    return CachedNetworkImage(
      imageUrl: uri,
      width: width,
      height: height,
      memCacheWidth: cachedWidth,
      memCacheHeight: cachedHeight,
      fit: fit,
    );
  }
}
