import 'package:flutter/material.dart';
import 'package:podcast/extensions/nullability_extensions.dart';

class RoundedImage extends StatelessWidget {
  final String? imageUrl;
  final bool showDot;

  const RoundedImage({
    required this.imageUrl,
    required this.showDot,
    super.key,
  });

  static const _imageSize = 40;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 3, bottom: 3),
          child: SizedBox(
            height: _imageSize.toDouble(),
            width: _imageSize.toDouble(),
            child: imageUrl?.let(
                  (url) => ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      width: _imageSize.toDouble(),
                      height: _imageSize.toDouble(),
                      url,
                      cacheHeight: _imageSize,
                      cacheWidth: _imageSize,
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
