import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class PotentiallyCachedImage extends StatelessWidget {
  final String uri;
  final double? width;
  final double? height;
  final int? cachedWidth;
  final int? cachedHeight;

  const PotentiallyCachedImage(
    this.uri, {
    super.key,
    this.width,
    this.height,
    this.cachedWidth,
    this.cachedHeight,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Image.network(
        uri,
        width: width,
        height: height,
        webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
      );
    }
    return CachedNetworkImage(
      imageUrl: uri.toString(),
      width: width,
      height: height,
      memCacheWidth: cachedWidth,
      memCacheHeight: cachedHeight,
    );
  }
}
