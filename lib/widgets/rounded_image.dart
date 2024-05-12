import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcast/extensions/nullability_extensions.dart';

class RoundedImage extends StatelessWidget {
  final Uri? imageUri;
  final bool showDot;
  final double? imageSize;

  const RoundedImage({
    required this.imageUri,
    this.showDot = false,
    this.imageSize,
    super.key,
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
            child: imageUri?.let(
                  (uri) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: uri.toString(),
                      width: imageSize,
                      height: imageSize,
                      memCacheWidth: scaledImageSize,
                      memCacheHeight: scaledImageSize,
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
