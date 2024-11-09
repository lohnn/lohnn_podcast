import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:podcast/data/episode_supabase.model.dart';
import 'package:podcast/data/podcast_supabase.model.dart';
import 'package:podcast/extensions/string_extensions.dart';
import 'package:podcast/providers/episodes_provider.dart';
import 'package:podcast/screens/async_value_screen.dart';
import 'package:podcast/widgets/pub_date_text.dart';
import 'package:podcast/widgets/rounded_image.dart';

class EpisodeListSupabaseScreen
    extends AsyncValueWidget<(PodcastSupabase, List<EpisodeSupabase>)> {
  final String podcastId;

  const EpisodeListSupabaseScreen(this.podcastId, {super.key});

  @override
  EpisodesProvider get provider => episodesProvider(podcastId: podcastId);

  @override
  Widget buildWithData(
    BuildContext context,
    WidgetRef ref,
    AsyncData<(PodcastSupabase, List<EpisodeSupabase>)> data,
  ) {
    // TODO: Verify why provider is rebuilding multiple times
    final (podcast, episodes) = data.value;
    return Scaffold(
      appBar: AppBar(title: Text(podcast.name)),
      body: RefreshIndicator(
        // onRefresh: () => ref.read(provider.notifier).updateList(),
        onRefresh: () async {},
        child: ListView.builder(
          itemCount: episodes.length,
          itemBuilder: (context, index) {
            final episode = episodes[index];
            return ListTile(
              onTap: () {
                context.push('/new/$podcastId/${episode.id}');
              },
              leading: RoundedImage(
                imageUri: episode.imageUrl.uri,
                // showDot: !episode.listened,
                showDot: true,
                imageSize: 40,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (episode.pubDate case final pubDate?)
                    DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w200,
                      ),
                      child: PubDateText(pubDate),
                    ),
                  Text(episode.title),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (episode.description case final description?)
                    Text(
                      description.removeHtmlTags(),
                      maxLines: 2,
                    ),
                  Row(
                    children: [
                      // PlayEpisodeButton(episodeSnapshot),
                      IconButton(
                        onPressed: () {
                          // ref
                          //     .read(podcastUserPodProvider.notifier)
                          //     .addToQueue(episodeSnapshot.reference);
                        },
                        icon: const Icon(Icons.playlist_add),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: PopupMenuButton<_PopupActions>(
                itemBuilder: (context) => [
                  // if (!episode.listened)
                  if (!false)
                    const PopupMenuItem(
                      value: _PopupActions.markListened,
                      child: Text('Mark listened'),
                    )
                  else
                    const PopupMenuItem(
                      value: _PopupActions.markUnlistened,
                      child: Text('Mark unlistened'),
                    ),
                ],
                icon: const Icon(Icons.more_vert),
                onSelected: (value) async {
                  // switch (value) {
                  //   case _PopupActions.markListened:
                  //     await episodeSnapshot.markListened();
                  //   case _PopupActions.markUnlistened:
                  //     await episodeSnapshot.markUnlistened();
                  // }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

enum _PopupActions {
  markListened,
  markUnlistened,
  ;
}
