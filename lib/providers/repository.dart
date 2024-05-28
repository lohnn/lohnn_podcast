import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/extensions/map_extensions.dart';
import 'package:podcast/extensions/response_extension.dart';
import 'package:podcast/providers/isolate_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xml/xml.dart';

part 'repository.g.dart';

@Riverpod(keepAlive: true)
Dio _dio(_DioRef ref) {
  return Dio();
}

@riverpod
Future<Response<T>> _fetchUrl<T>(
  _FetchUrlRef<T> ref,
  String url,
) {
  final dio = ref.watch(_dioProvider);
  return dio.getUri<T>(Uri.parse(url));
}

@riverpod
Future<Podcast> fetchPodcast(FetchPodcastRef ref, String rssUrl) async {
  final response = await ref.watch(_fetchUrlProvider<String>(rssUrl).future);
  final isolate = ref.watch(isolateProvider(const ValueKey('xml')));

  return await isolate.compute(
    (message) {
      final (xml, rssUrl) = message;
      final xmlDoc = XmlDocument.parse(xml);
      return Podcast.fromXml(xmlDoc, rssUrl);
    },
    (response.data!, rssUrl),
  );
}

@riverpod
Future<Map<String, List<String>>> fetchListenedEpisodes(
  FetchListenedEpisodesRef ref,
  String jsonUrl,
) async {
  final response = (await ref.watch(
        _fetchUrlProvider<Map<String, dynamic>>(jsonUrl).future,
      ))
          .data ??
      const {};

  return {
    for (final (podcastName, List<dynamic> episodes) in response.records)
      if (episodes.isNotEmpty) podcastName: episodes.cast(),
  };
}

@riverpod
Future<Iterable<Episode>> fetchEpisodes(
  FetchEpisodesRef ref,
  Podcast podcast,
) async {
  final response = await ref.watch(
    _fetchUrlProvider(podcast.rssUrl).future,
  );
  return response.xmlAsSingle(
    (document) => Episode.fromXml(document, podcast: podcast),
  );
}
