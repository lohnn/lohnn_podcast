import 'package:flutter/material.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/screens/podcast_details_screen.dart';
import 'package:podcast/widgets/rounded_image.dart';

class PodcastListTile extends StatelessWidget {
  final PodcastId podcastId;
  final Podcast podcast;

  const PodcastListTile(
    this.podcastId,
    this.podcast, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        // @TODO: Navigate named
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PodcastDetailsScreen(podcastId, podcast),
          ),
        );
      },
      leading: RoundedImage(
        imageUrl: podcast.image,
        showDot: podcast.showDot ?? false,
      ),
      title: Text(podcast.name),
      trailing: Text('${podcast.unlistenedEpisodes}/${podcast.totalEpisodes}'),
    );
  }
}
