import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:podcast/data/podcast.dart';
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
        context.push('/podcast', extra: podcastSnapshot);
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
