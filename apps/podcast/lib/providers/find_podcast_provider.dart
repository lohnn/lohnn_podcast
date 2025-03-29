import 'package:podcast/brick/repository.dart';
import 'package:podcast/data/podcast_search.model.dart';
import 'package:podcast/helpers/debouncer.dart';
import 'package:podcast/providers/podcasts_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'find_podcast_provider.g.dart';

@riverpod
class FindPodcast extends _$FindPodcast {
  final _searchDebouncer = Debouncer.long();

  @override
  Future<List<PodcastSearch>> build() {
    return Repository().findPodcasts();
  }

  Future<void> search(String searchTerm) async {
    state = const AsyncLoading();
    _searchDebouncer.run(() async {
      try {
        final podcasts = await Repository().findPodcasts(searchTerm);
        state = AsyncData(podcasts);
      } catch (e, stackTrace) {
        state = AsyncError(e, stackTrace);
      }
    });
  }

  Future<void> subscribe(String podcastUrl) {
    return ref.read(podcastsProvider.notifier).subscribe(podcastUrl);
  }

  Future<void> unsubscribe(String podcastUrl) {
    return ref.read(podcastsProvider.notifier).unsubscribe(podcastUrl);
  }
}
