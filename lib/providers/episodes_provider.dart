import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:podcast/brick/repository.dart';
import 'package:podcast/data/episode.model.dart';
import 'package:podcast/data/episode_with_status.dart';
import 'package:podcast/data/podcast.model.dart';
import 'package:podcast/extensions/async_value_extensions.dart';
import 'package:podcast/helpers/equatable_list.dart';
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
    final podcast = ref.watch(podcastProvider(podcastId));

    final userEpisodeStatusList =
        ref.watch(userEpisodeStatusPodProvider).valueOrNull ?? {};

    final episodes =
        ref.watch(_episodesImplProvider(podcastId)).whenData((episodes) {
      return [
        for (final episode in episodes)
          EpisodeWithStatus(
            episode: episode,
            status: userEpisodeStatusList[episode.id],
          ),
      ];
    }).whenData(EquatableList.new);
    return (podcast, episodes).pack();
  }

  Future<void> updateList() {
    final (podcast, _) = state.requireValue;
    return ref.read(podcastsProvider.notifier).refresh(podcast);
  }
}

@riverpod
Stream<List<Episode>> _episodesImpl(
  _EpisodesImplRef ref,
  String podcastId,
) {
  final query = Query(
    where: [Where('podcastId', value: podcastId)],
    providerArgs: {
      'orderBy': 'pubDate DESC',
      // @TODO: Look into adding pagination
    },
  );

  return Repository().subscribeToRealtime<Episode>(query: query);
}
