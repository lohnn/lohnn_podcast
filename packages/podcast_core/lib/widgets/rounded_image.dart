import 'package:flutter/material.dart';
import 'package:podcast_core/extensions/nullability_extensions.dart';
import 'package:podcast_core/widgets/potentially_cached_image.dart';

class RoundedImage extends StatelessWidget {
  final Uri? imageUri;
  final bool showDot;
  final double? imageSize;
  final BoxFit? fit;
  final double? radius;
  final String semanticLabel;

  const RoundedImage({
    super.key,
    required this.imageUri,
    required this.semanticLabel,
    this.showDot = false,
    this.imageSize,
    this.fit,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final scaledImageSize = switch (imageSize) {
      null => null,
      final imageSize => (imageSize * pixelRatio).round(),
    };

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 3, bottom: 3),
          child: SizedBox(
            height: imageSize,
            width: imageSize,
            child:
                imageUri?.let(
                  (uri) => ClipRRect(
                    borderRadius: BorderRadius.circular(radius ?? 8),
                    child: PotentiallyCachedImage(
                      semanticLabel: semanticLabel,
                      uri.toString(),
                      width: imageSize,
                      height: imageSize,
                      cachedWidth: scaledImageSize,
                      cachedHeight: scaledImageSize,
                      fit: fit,
                    ),
                  ),
                ) ??
                const Placeholder(),
          ),
        ),
        if (showDot)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: const Color(0xffEA7F00),
              ),
            ),
          ),
      ],
    );
  }
}
