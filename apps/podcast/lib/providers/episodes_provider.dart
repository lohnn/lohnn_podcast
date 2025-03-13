import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:podcast/brick/repository.dart';
import 'package:podcast/data/episode.model.dart';
import 'package:podcast/data/episode_with_status.dart';
import 'package:podcast/data/podcast.model.dart';
import 'package:podcast/extensions/async_value_extensions.dart';
import 'package:podcast/helpers/equatable_list.dart';
import 'package:podcast/helpers/equatable_map.dart';
import 'package:podcast/providers/app_lifecycle_state_provider.dart';
import 'package:podcast/providers/podcasts_provider.dart';
import 'package:podcast/providers/user_episode_status_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'episodes_provider.g.dart';

@riverpod
class EpisodePod extends _$EpisodePod {
  @override
  AsyncValue<(Podcast, EpisodeWithStatus)> build({
    required String podcastId,
    required String episodeId,
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
    required String podcastId,
  }) {
    final podcast = ref.watch(podcastPodProvider(podcastId));

    // Opened the podcast screen, update the last seen timestamp
    updateLastSeen();

    final userEpisodeStatusList =
        ref.watch(userEpisodeStatusPodProvider).valueOrNull ??
        const EquatableMap.empty();

    final episodes = ref
        .watch(_episodesImplProvider(podcastId))
        .whenData((episodes) {
          return [
            for (final episode in episodes)
              EpisodeWithStatus(
                episode: episode,
                status: userEpisodeStatusList[episode.id],
              ),
          ];
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
Stream<List<Episode>> _episodesImpl(
  _EpisodesImplRef ref,
  String podcastId,
) async* {
  final lifecycleState = ref.watch(appLifecycleStatePodProvider);
  if (lifecycleState != AppLifecycleState.resumed) return;

  final query = Query(
    where: [Where('podcastId', value: podcastId)],
    orderBy: [const OrderBy('pubDate', ascending: false)],
    // @TODO: Look into adding pagination
  );

  yield* Repository().subscribeToRealtime<Episode>(query: query);
}
