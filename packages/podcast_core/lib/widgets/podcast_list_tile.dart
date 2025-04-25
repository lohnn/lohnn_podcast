import 'package:flutter/material.dart';
import 'package:podcast_core/data/podcast_search.model.dart';
import 'package:podcast_core/widgets/rounded_image.dart';

class PodcastListTile extends StatelessWidget {
  final Uri imageUrl;
  final String name;
  final Widget? trailing;
  final bool showDot;
  final VoidCallback onTap;

  const PodcastListTile({
    required this.imageUrl,
    required this.name,
    this.trailing,
    this.showDot = false,
    super.key,
    required this.onTap,
  });

  factory PodcastListTile.podcast(
    PodcastSearch podcast, {
    Key? key,
    Widget? trailing,
    bool? showDot,
    required VoidCallback onTap,
  }) {
    return PodcastListTile(
      key: key,
      imageUrl: podcast.artwork,
      name: podcast.title,
      trailing: trailing,
      showDot: showDot ?? false,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: RoundedImage(
        imageUri: imageUrl,
        showDot: showDot,
        imageSize: 40,
      ),
      title: Text(name),
      trailing: trailing,
    );
  }
}
