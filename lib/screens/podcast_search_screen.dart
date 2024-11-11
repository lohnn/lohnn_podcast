import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/podcast_supabase.model.dart';
import 'package:podcast/providers/find_podcast_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/widgets/podcast_supabase_list_tile.dart';

class PodcastSearchScreen extends AsyncValueWidget<
    List<({PodcastSupabase podcast, bool isSubscribed})>> {
  const PodcastSearchScreen({super.key});

  @override
  ProviderBase<AsyncValue<List<({PodcastSupabase podcast, bool isSubscribed})>>>
      get provider => findPodcastProvider;

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    List<({PodcastSupabase podcast, bool isSubscribed})> data,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Podcasts'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final (:podcast, :isSubscribed) = data[index];
          return PodcastSupabaseListTile(
            key: ValueKey(podcast),
            podcast,
            trailing: isSubscribed
                ? IconButton(
                    onPressed: () {
                      ref
                          .read(findPodcastProvider.notifier)
                          .unsubscribe(podcast);
                    },
                    icon: const Icon(Icons.check),
                  )
                : IconButton(
                    onPressed: () {
                      ref.read(findPodcastProvider.notifier).subscribe(podcast);
                    },
                    icon: const Icon(Icons.add),
                  ),
          );
        },
      ),
    );
  }
}
