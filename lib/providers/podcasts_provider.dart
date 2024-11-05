import 'package:podcast/brick/repository.dart';
import 'package:podcast/data/podcast_supabase.model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'podcasts_provider.g.dart';

@riverpod
class Podcasts extends _$Podcasts {
  @override
  Stream<List<PodcastSupabase>> build() {
    syncWithRemote();
    return Repository().subscribeToRealtime<PodcastSupabase>();
  }

  Future<void> syncWithRemote() {
    return Repository().get<PodcastSupabase>(forceLocalSyncFromRemote: true);
  }
}
