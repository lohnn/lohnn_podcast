import 'package:flutter/material.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/extensions/nullability_extensions.dart';
import 'package:podcast/screens/podcast_screen.dart';

class PodcastListTile extends StatelessWidget {
  final Podcast podcast;
  final int total;
  final int unlistened;
  final bool hasNew;

  const PodcastListTile(
    this.podcast, {
    super.key,
    required this.hasNew,
    required this.total,
    required this.unlistened,
  });

  static const _imageSize = 40;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // @TODO: Navigate named
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => PodcastScreen(podcast)),
        );
      },
      trailing: Text('$unlistened/$total'),
      leading: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 3, bottom: 3),
            child: SizedBox(
              height: _imageSize.toDouble(),
              width: _imageSize.toDouble(),
              child: podcast.image?.let(
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
          if (hasNew)
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
      ),
      title: Text(podcast.name),
    );
  }
}
