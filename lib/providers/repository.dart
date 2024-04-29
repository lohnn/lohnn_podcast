import 'package:dio/dio.dart';
import 'package:podcast/data/podcast.dart';
import 'package:podcast/extensions/response_extension.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository.g.dart';

@Riverpod(keepAlive: true)
Dio _dio(_DioRef ref) {
  return Dio();
}

@riverpod
Future<Podcast> fetchPodcast(FetchPodcastRef ref, Uri rssUrl) async {
  final dio = ref.watch(_dioProvider);
  final response = await dio.getUri(rssUrl);

  return response.xmlAsSingle(
    (document) => Podcast.fromXml(document, rssUrl.toString()),
  );
}
