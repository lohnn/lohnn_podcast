import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:podcast/data/podcast_supabase.model.dart';
import 'package:podcast/widgets/rounded_image.dart';

class PodcastSupabaseListTile extends StatelessWidget {
  final PodcastSupabase podcast;

  const PodcastSupabaseListTile(
    this.podcast, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        context.push('/${podcast.id}', extra: podcast);
      },
      leading: RoundedImage(
        imageUri: podcast.imageUrl.uri,
        showDot: false, //podcast.showDot,
        imageSize: 40,
      ),
      title: Text(podcast.name),
      trailing: const Text(
        '${2}/${8}',
        // '${podcast.listenedEpisodes.length}/${podcast.totalEpisodes}',
      ),
    );
  }
}
