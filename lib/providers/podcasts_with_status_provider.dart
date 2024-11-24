import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:podcast/brick/repository.dart';
import 'package:podcast/data/podcast_with_status.dart';
import 'package:podcast/helpers/equatable_iterable.dart';
import 'package:podcast/helpers/equatable_list.dart';
import 'package:podcast/providers/podcasts_provider.dart';
import 'package:podcast/providers/user_episode_status_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'podcasts_with_status_provider.g.dart';

@riverpod
class PodcastsWithStatus extends _$PodcastsWithStatus {
  final _query = Query(providerArgs: {'orderBy': 'name ASC'});

  @override
  Future<EquatableList<PodcastWithStatus>> build() {
    // @TODO: Maybe find a way to store the value locally as well for offline first

    // keepUpToDateWithSubscriptions();

    _listenPodcastChanges();
    _listenToTableChanges();

    return future;
  }

  void _listenToTableChanges() {
    // New episodes should trigger a reload
    // @TODO: Trigger reload only on the podcast to which the episode belongs
    ref.listen(
      watchTableProvider('episodes', event: PostgresChangeEvent.insert),
      (oldValue, newValue) {
        if (oldValue == null) return;
        if (newValue == null) return;
        ref.invalidateSelf();
      },
    );

    // @TODO: Trigger reload only on the podcast to which the episode belongs
    ref.listen(
      userEpisodeStatusPodProvider,
      (oldValue, newValue) {
        final oldStatus = oldValue?.valueOrNull;
        final newStatus = newValue.valueOrNull;
        if (oldStatus == null) return;
        if (newStatus == null) return;
        if (oldStatus == newStatus) return;

        final oldListenedStatus =
            oldStatus.values.map((value) => value.isPlayed).equatable;
        final newListenedStatus =
            newStatus.values.map((value) => value.isPlayed).equatable;

        if (oldListenedStatus != newListenedStatus) {
          ref.invalidateSelf();
        }
      },
    );
  }

  void _listenPodcastChanges() {
    ref.listen(
      podcastsProvider,
      fireImmediately: true,
      (oldValue, newValue) async {
        final oldPodcasts = oldValue?.valueOrNull;
        final newPodcasts = newValue.valueOrNull;

        // If there is no podcasts in new value, we can just skip this
        if (newPodcasts == null) return;
        // Podcast list didn't actually update, let's just ignore
        if (newPodcasts == oldPodcasts) return;
        // If we don't already show data, let's first show converted null list
        if (state is! AsyncData) {
          state = AsyncData(
            [
              for (final podcast in newPodcasts)
                PodcastWithStatus.notListened(podcast: podcast),
            ].equatable,
          );
        }

        final podcastsWithCount = await Repository()
            .remoteProvider
            .client
            .rpc<List<Map<String, dynamic>>>(
              'podcast_with_count',
            );

        state = AsyncData(
          <PodcastWithStatus>[
            for (final podcast in podcastsWithCount)
              if (podcast
                  case {
                    'podcast_id': final String podcastId,
                    'episode_count': final int episodeCount,
                    'played_episode_count': final int playedEpisodeCount,
                  })
                PodcastWithStatus(
                  podcast: newPodcasts
                      .firstWhere((podcast) => podcast.id == podcastId),
                  listenedEpisodes: playedEpisodeCount,
                  totalEpisodes: episodeCount,
                ),
          ].equatable,
        );
      },
    );
  }
}
