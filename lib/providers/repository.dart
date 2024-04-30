import 'package:dio/dio.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/extensions/response_extension.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository.g.dart';

@Riverpod(keepAlive: true)
Dio _dio(_DioRef ref) {
  return Dio();
}

@Riverpod(keepAlive: true)
Future<Response<dynamic>> _fetchPodcastXml(
  _FetchPodcastXmlRef ref,
  String rssUrl,
) {
  final dio = ref.watch(_dioProvider);
  return dio.getUri(Uri.parse(rssUrl));
}

@Riverpod(keepAlive: true)
Future<Podcast> fetchPodcast(FetchPodcastRef ref, String rssUrl) async {
  ref.onDispose(() => ref.invalidate(_fetchPodcastXmlProvider(rssUrl)));

  final response = await ref.watch(_fetchPodcastXmlProvider(rssUrl).future);
  return response.xmlAsSingle(
    (document) => Podcast.fromXml(document, rssUrl),
  );
}

@Riverpod(keepAlive: true)
Future<Iterable<Episode>> fetchEpisodes(
  FetchEpisodesRef ref,
  Podcast podcast,
) async {
  ref.onDispose(
    () => ref.invalidate(_fetchPodcastXmlProvider(podcast.rssUrl)),
  );

  final response = await ref.watch(
    _fetchPodcastXmlProvider(podcast.rssUrl).future,
  );
  return response.xmlAsSingle(Episode.fromXml);
}
