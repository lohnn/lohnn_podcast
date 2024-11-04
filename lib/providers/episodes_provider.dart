import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:podcast/brick/repository.dart';
import 'package:podcast/data/episode_supabase.model.dart';
import 'package:podcast/data/serdes/uri_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

part 'episodes_provider.g.dart';

@riverpod
class Episodes extends _$Episodes {
  @override
  Stream<List<EpisodeSupabase>> build() {
    syncWithRemote();
    return Repository().subscribeToRealtime<EpisodeSupabase>();
  }

  Future<void> syncWithRemote() {
    return Repository().get<EpisodeSupabase>(forceLocalSyncFromRemote: true);
  }

  Future<void> delete(EpisodeSupabase episode) {
    return Repository().delete<EpisodeSupabase>(episode);
  }

  Future<void> createNew() {
    return Repository().upsert<EpisodeSupabase>(
      policy: OfflineFirstUpsertPolicy.requireRemote,
      EpisodeSupabase(
        id: const Uuid().v1(),
        podcastId: 'https://rss.art19.com/sitcom-dnd',
        url: UriModel('https://lohnn.se/'),
        title: 'Lohnn podcast',
        imageUrl: UriModel('https://lohnn.se/'),
      ),
    );
  }

  Future<void> updateEpisode(EpisodeSupabase episode) {
    return Repository()
        .upsert<EpisodeSupabase>(episode.copyWith(title: '${episode.title}1'));
  }
}
