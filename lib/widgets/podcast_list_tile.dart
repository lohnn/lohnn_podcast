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
        context.push('/${podcastSnapshot.id}', extra: podcastSnapshot);
      },
      leading: RoundedImage(
        imageUri: podcast.image,
        showDot: podcast.showDot,
        imageSize: 40,
      ),
      title: Text(podcast.name),
      trailing: Text('${podcast.listenedEpisodes}/${podcast.totalEpisodes}'),
    );
  }
}
