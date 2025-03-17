import 'package:podcast/brick/repository.dart';
import 'package:podcast/data/podcast_search.model.dart';
import 'package:podcast/helpers/debouncer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'find_podcast_provider.g.dart';

@riverpod
class FindPodcast extends _$FindPodcast {
  final _searchDebouncer = Debouncer.short();

  @override
  Future<List<PodcastSearch>> build() {
    return Repository().findPodcasts();
  }

  Future<void> search(String searchTerm) async {
    state = const AsyncLoading();
    _searchDebouncer.run(() async {
      final podcasts = await Repository().findPodcasts(searchTerm);
      state = AsyncData(podcasts);
    });
  }

  void subscribe(PodcastSearch podcast) {
    Repository().remoteProvider.client.functions.invoke(
      'subscribe_to_podcast',
      body: podcast.url,
    );
  }

  void unsubscribe(PodcastSearch podcast) {
    Repository().remoteProvider.client.functions.invoke(
      'unsubscribe_from_podcast',
      body: podcast.url,
    );
  }
}
