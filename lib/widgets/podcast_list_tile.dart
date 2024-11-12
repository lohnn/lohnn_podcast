import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:podcast/data/podcast.model.dart';
import 'package:podcast/widgets/rounded_image.dart';

class PodcastListTile extends StatelessWidget {
  final Podcast podcast;
  final Widget? trailing;

  const PodcastListTile(
    this.podcast, {
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.push('/${podcast.safeId}', extra: podcast);
      },
      leading: RoundedImage(
        imageUri: podcast.imageUrl.uri,
        // showDot:  podcast.showDot,
        imageSize: 40,
      ),
      title: Text(podcast.name),
      trailing: trailing ??
          const Text(
            '?/?',
            // '${podcast.listenedEpisodes.length}/${podcast.totalEpisodes}',
          ),
    );
  }
}
