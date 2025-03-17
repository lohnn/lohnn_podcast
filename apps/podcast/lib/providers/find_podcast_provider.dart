import 'package:podcast/brick/repository.dart';
import 'package:podcast/data/podcast.model.dart';
import 'package:podcast/data/podcast_search.model.dart';
import 'package:podcast/helpers/debouncer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'find_podcast_provider.g.dart';

@riverpod
class FindPodcast extends _$FindPodcast {
  final _searchDebouncer = Debouncer.short();

  @override
  Future<List<PodcastSearch>> build() {
    // final podcastUrls = await ref.watch(
    //   podcastsProvider.selectAsync(
    //     (podcasts) => podcasts.map((podcast) => podcast.rssUrl),
    //   ),
    // );
    return Repository().findPodcasts();
    // return (podcastUrls, trendingPodcasts).pack().whenData((tuple) {
    //   final (myPodcasts, podcasts) = tuple;
    //   return [
    //     for (final podcast in podcasts)
    //       (
    //         podcast: podcast,
    //         isSubscribed: myPodcasts.contains(podcast.url.uri.toString()),
    //       ),
    //   ];
    // });
  }

  Future<void> search(String searchTerm) async {
    state = const AsyncLoading();
    _searchDebouncer.run(() async {
      final podcasts = await Repository().findPodcasts(searchTerm);
      state = AsyncData(podcasts);
    });
  }

  void subscribe(Podcast podcast) {
    Repository().remoteProvider.client.functions.invoke(
      'subscribe_to_podcast',
      body: podcast.id,
    );
  }

  void unsubscribe(Podcast podcast) {
    Repository().remoteProvider.client.functions.invoke(
      'unsubscribe_from_podcast',
      body: podcast.id,
    );
  }
}
