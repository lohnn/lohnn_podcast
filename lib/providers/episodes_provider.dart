import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:podcast/brick/repository.dart';
import 'package:podcast/data/episode_supabase.model.dart';
import 'package:podcast/data/podcast_supabase.model.dart';
import 'package:podcast/extensions/async_value_extensions.dart';
import 'package:podcast/helpers/equatable_list.dart';
import 'package:podcast/providers/podcasts_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'episodes_provider.g.dart';

@riverpod
class Episodes extends _$Episodes {
  @override
  AsyncValue<(PodcastSupabase, List<EpisodeSupabase>)> build({
    required String podcastId,
  }) {
    final podcast = ref.watch(podcastProvider(podcastId));
    final episodes =
        ref.watch(_episodesImplProvider(podcastId)).whenData(EquatableList.new);
    return (podcast, episodes).pack();
  }
}

@riverpod
Stream<List<EpisodeSupabase>> _episodesImpl(
  _EpisodesImplRef ref,
  String podcastId,
) {
  final query = Query(
    where: [Where('podcastId', value: podcastId)],
    providerArgs: {
      'orderBy': 'pubDate DESC',
    },
  );

  Repository().get<EpisodeSupabase>(
    forceLocalSyncFromRemote: true,
    query: query,
  );
  return Repository().subscribeToRealtime<EpisodeSupabase>(query: query);
}
