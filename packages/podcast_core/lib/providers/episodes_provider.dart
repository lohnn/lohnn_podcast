import 'dart:async';

import 'package:collection/collection.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/data/episode_with_status.dart';
import 'package:podcast_core/data/podcast.model.dart';
import 'package:podcast_core/extensions/async_value_extensions.dart';
import 'package:podcast_core/helpers/equatable_list.dart';
import 'package:podcast_core/helpers/equatable_map.dart';
import 'package:podcast_core/providers/app_lifecycle_state_provider.dart';
import 'package:podcast_core/providers/episodes_filter_provider.dart';
import 'package:podcast_core/providers/podcasts_provider.dart';
import 'package:podcast_core/providers/user_episode_status_provider.dart';
import 'package:podcast_core/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'episodes_provider.g.dart';

@riverpod
class EpisodePod extends _$EpisodePod {
  @override
  AsyncValue<(Podcast, EpisodeWithStatus)> build({
    required PodcastId podcastId,
    required EpisodeId episodeId,
  }) {
    return ref.watch(episodesProvider(podcastId: podcastId)).whenData((pair) {
      final (podcast, episodes) = pair;
      final episode = episodes.firstWhere(
        (episodeWithStatus) => episodeWithStatus.episode.id == episodeId,
      );

      return (podcast, episode);
    });
  }
}

@riverpod
class Episodes extends _$Episodes {
  @override
  AsyncValue<(Podcast, List<EpisodeWithStatus>)> build({
    required PodcastId podcastId,
  }) {
    final filterState = ref.watch(episodesFilterProvider);

    final podcast = ref.watch(podcastPodProvider(podcastId));

    final userEpisodeStatusList =
        ref.watch(userEpisodeStatusPodProvider).value ??
        const EquatableMap.empty();

    final episodes = ref
        .watch(_episodesImplProvider(podcastId))
        .whenData((episodes) {
          return episodes.map(
            (episode) => EpisodeWithStatus(
              episode: episode,
              status: userEpisodeStatusList[episode.id],
            ),
          );
        })
        .whenData((episodes) {
          // Filtering and sorting

          final filteredEpisodes = switch (filterState.hideListenedEpisodes) {
            true => episodes.whereNot((episode) => episode.isPlayed),
            false => episodes,
          };

          return filterState.sortEpisodes(filteredEpisodes);
        })
        .whenData(EquatableList.new);

    return (podcast, episodes).pack();
  }

  /// Update the last seen timestamp for the podcast
  Future<void> updateLastSeen() {
    return ref.read(podcastPodProvider(podcastId).notifier).updateLastSeen();
  }

  Future<void> updateList() {
    final (podcast, _) = state.requireValue;
    return ref.read(podcastsProvider.notifier).refresh(podcast);
  }

  Future<void> markListened(EpisodeWithStatus episodeWithStatus) {
    return ref
        .read(userEpisodeStatusPodProvider.notifier)
        .markListened(episodeWithStatus);
  }

  Future<void> markUnlistened(EpisodeWithStatus episodeWithStatus) {
    return ref
        .read(userEpisodeStatusPodProvider.notifier)
        .markUnlistened(episodeWithStatus);
  }
}

@riverpod
Stream<List<Episode>> _episodesImpl(Ref ref, PodcastId podcast) {
  final lifecycleState = ref.watch(appLifecycleStatePodProvider);
  if (lifecycleState != AppLifecycleState.resumed) return const Stream.empty();

  return ref.watch(repositoryProvider).watchEpisodesFor(podcast: podcast);
}
