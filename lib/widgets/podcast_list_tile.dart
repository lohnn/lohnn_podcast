import 'package:flutter/material.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/providers/firebase/firestore/podcast_list_pod_provider.dart';
import 'package:podcast/screens/podcast_details_screen.dart';
import 'package:podcast/widgets/rounded_image.dart';

class PodcastListTile extends StatelessWidget {
  final Podcast podcast;

  // final int total;
  // final int unlistened;
  // final bool hasNew;

  const PodcastListTile(
    this.podcast, {
    super.key,
    // required this.hasNew,
    // required this.total,
    // required this.unlistened,
  });

  @override
  Widget build(BuildContext context) {
    // final PodcastListRow(
    //   :podcast,
    //   :hasNew,
    //   totalEpisodes: total,
    //   unlistenedEpisodes: unlistened,
    // ) = podcastRow;
    return ListTile(
      onTap: () {
        // @TODO: Navigate named
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PodcastDetailsScreen(podcast),
          ),
        );
      },
      // trailing: Text('$unlistened/$total'),
      leading: RoundedImage(
        imageUrl: podcast.image,
        showDot: true,
      ),
      title: Text(podcast.name),
    );
  }
}
