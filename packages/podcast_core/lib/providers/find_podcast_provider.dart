import 'package:podcast_core/data/podcast_search.model.dart';
import 'package:podcast_core/helpers/debouncer.dart';
import 'package:podcast_core/providers/podcasts_provider.dart';
import 'package:podcast_core/repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'find_podcast_provider.g.dart';

@riverpod
class FindPodcast extends _$FindPodcast {
  final _searchDebouncer = Debouncer.long();
  late Repository _repository;

  @override
  Future<List<PodcastSearch>> build() {
    return (_repository = ref.watch(repositoryProvider)).findPodcasts();
  }

  Future<void> search(String searchTerm) async {
    state = const AsyncLoading();
    _searchDebouncer.run(() async {
      try {
        final podcasts = await _repository.findPodcasts(searchTerm);
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
