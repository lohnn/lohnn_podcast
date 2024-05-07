import 'package:flutter/material.dart';
import 'package:podcast/extensions/nullability_extensions.dart';

class RoundedImage extends StatelessWidget {
  final String? imageUrl;
  final bool showDot;
  final int? imageSize;

  const RoundedImage({
    required this.imageUrl,
    this.showDot = false,
    this.imageSize,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 3, bottom: 3),
          child: SizedBox(
            height: imageSize?.toDouble(),
            width: imageSize?.toDouble(),
            child: imageUrl?.let(
                  (url) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      width: imageSize?.toDouble(),
                      height: imageSize?.toDouble(),
                      url,
                      cacheHeight: imageSize,
                      cacheWidth: imageSize,
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
