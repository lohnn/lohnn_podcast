import 'package:podcast/brick/repository.dart';
import 'package:podcast/data/podcast_supabase.model.dart';
import 'package:podcast/extensions/async_value_extensions.dart';
import 'package:podcast/providers/podcasts_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'find_podcast_provider.g.dart';

@riverpod
class FindPodcast extends _$FindPodcast {
  @override
  AsyncValue<List<({PodcastSupabase podcast, bool isSubscribed})>> build() {
    return (
      ref.watch(podcastsProvider),
      ref.watch(_findPodcastImplProvider),
    ).pack().whenData((tuple) {
      final (myPodcasts, podcasts) = tuple;
      return [
        for (final podcast in podcasts)
          (podcast: podcast, isSubscribed: myPodcasts.contains(podcast)),
      ];
    });
  }

  void subscribe(PodcastSupabase podcast) {
    Repository().remoteProvider.client.functions.invoke(
          'subscribe_to_podcast',
          body: podcast.id,
        );
  }

  void unsubscribe(PodcastSupabase podcast) {
    Repository().remoteProvider.client.functions.invoke(
          'unsubscribe_from_podcast',
          body: podcast.id,
        );
  }
}

@riverpod
Future<Iterable<PodcastSupabase>> _findPodcastImpl(
    _FindPodcastImplRef ref) async {
  final podcastsResponse = await Repository()
      .remoteProvider
      .client
      .functions
      .invoke('find_podcasts');

  final data =
      (podcastsResponse.data as List<dynamic>).cast<Map<String, dynamic>>();
  return data.map(PodcastSupabaseMapper.fromMap);
}
