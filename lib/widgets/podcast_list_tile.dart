import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/extensions/nullability_extensions.dart';
import 'package:podcast/providers/firebase/firestore/episodes_pod_provider.dart';

class PodcastListTile extends ConsumerWidget {
  final Podcast podcast;

  const PodcastListTile(this.podcast, {super.key});

  static const _imageSize = 40;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodes = ref.watch(episodesPodProvider(podcast));

    // print(episodes.valueOrNull?.length);
    return ListTile(
      contentPadding: const EdgeInsets.all(12),
      onTap: () {},
      trailing: episodes.valueOrNull?.let(
        (data) => Text(data.length.toString()),
      ),
      leading: SizedBox(
        height: _imageSize.toDouble(),
        width: _imageSize.toDouble(),
        child: podcast.image?.let(
              (url) => ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  width: _imageSize.toDouble(),
                  height: _imageSize.toDouble(),
                  url,
                  cacheHeight: _imageSize,
                  cacheWidth: _imageSize,
                ),
              ),
            ) ??
            const Placeholder(),
      ),
      title: Text(podcast.name),
    );
  }
}
