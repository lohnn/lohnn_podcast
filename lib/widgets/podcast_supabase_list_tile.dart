import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:podcast/data/podcast_supabase.model.dart';
import 'package:podcast/widgets/rounded_image.dart';

class PodcastSupabaseListTile extends StatelessWidget {
  final PodcastSupabase podcast;
  final Widget? trailing;

  const PodcastSupabaseListTile(
    this.podcast, {
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.push('/new/${podcast.safeId}', extra: podcast);
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
