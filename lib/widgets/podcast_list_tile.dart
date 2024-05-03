import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/screens/podcast_details_screen.dart';
import 'package:podcast/widgets/rounded_image.dart';

class PodcastListTile extends StatelessWidget {
  final QueryDocumentSnapshot<Podcast> podcastSnapshot;

  const PodcastListTile(
    this.podcastSnapshot, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final podcast = podcastSnapshot.data();
    return ListTile(
      onTap: () {
        // @TODO: Navigate named
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PodcastDetailsScreen(podcastSnapshot),
          ),
        );
      },
      leading: RoundedImage(
        imageUrl: podcast.image,
        showDot: podcast.showDot,
      ),
      title: Text(podcast.name),
      trailing: Text('${podcast.listenedEpisodes}/${podcast.totalEpisodes}'),
    );
  }
}
