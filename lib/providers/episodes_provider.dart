import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:podcast/brick/repository.dart';
import 'package:podcast/data/episode_supabase.model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'episodes_provider.g.dart';

@riverpod
Stream<List<EpisodeSupabase>> episodes(EpisodesRef ref) {
  return Repository().subscribe<EpisodeSupabase>(
    policy: OfflineFirstGetPolicy.alwaysHydrate,
  );
}
