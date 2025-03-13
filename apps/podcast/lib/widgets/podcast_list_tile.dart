import 'package:flutter/material.dart';
import 'package:podcast/data/podcast.model.dart';
import 'package:podcast/widgets/rounded_image.dart';

class PodcastListTile extends StatelessWidget {
  final Podcast podcast;
  final Widget? trailing;
  final bool? showDot;
  final VoidCallback onTap;

  const PodcastListTile(
    this.podcast, {
    this.trailing,
    this.showDot,
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: RoundedImage(
        imageUri: podcast.imageUrl.uri,
        showDot: showDot ?? false,
        imageSize: 40,
      ),
      title: Text(podcast.name),
      trailing: trailing,
    );
  }
}
