import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:podcast/data/episode.model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'episode_loader_provider.g.dart';

sealed class EpisodeFileResponse {
  const EpisodeFileResponse({required this.remoteUri});

  Uri get currentUri => remoteUri;

  final Uri remoteUri;
}

final class RemoteEpisodeFile extends EpisodeFileResponse {
  const RemoteEpisodeFile({required super.remoteUri});
}

final class DownloadingEpisodeFile extends EpisodeFileResponse {
  final double progress;

  const DownloadingEpisodeFile({
    required super.remoteUri,
    required this.progress,
  });
}

final class LocalEpisodeFile extends EpisodeFileResponse {
  final Uri localUri;

  @override
  Uri get currentUri => localUri;

  const LocalEpisodeFile({
    required super.remoteUri,
    required this.localUri,
  });
}

@riverpod
class EpisodeLoader extends _$EpisodeLoader {
  static final _cacheManager = CacheManager(
    Config(
      'episodes',
      maxNrOfCacheObjects: 10,
      fileService: EpisodeFileService(),
    ),
  );

  @override
  Future<EpisodeFileResponse> build(Episode episode) async {
    final localFile = await _cacheManager.getFileFromCache(
      episode.url.uri.toString(),
    );
    if (localFile != null) {
      return LocalEpisodeFile(
        remoteUri: episode.url.uri,
        localUri: localFile.uri,
      );
    } else {
      // TODO: Somehow check if currently downloading
      return RemoteEpisodeFile(remoteUri: episode.url.uri);
    }
  }

  /// Downloads the episode and returns the URI to the file.
  ///
  /// During download, the uri will report the original URL of the episode.
  Stream<EpisodeFileResponse> load() async* {
    final status = await future;
    if (status is LocalEpisodeFile) {
      yield status;
      return;
    }

    await for (final fileResponse in _cacheManager.getFileStream(
      episode.url.uri.toString(),
      withProgress: true,
    )) {
      state = AsyncData(switch (fileResponse) {
        FileInfo(:final file) => LocalEpisodeFile(
            remoteUri: episode.url.uri,
            localUri: file.uri,
          ),
        FileResponse(:final originalUrl) => RemoteEpisodeFile(
            remoteUri: Uri.parse(originalUrl),
          ),
      });
    }
  }
}

class EpisodeFileService extends FileService {
  final http.Client _httpClient = http.Client();

  EpisodeFileService();

  @override
  Future<FileServiceResponse> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    final req = http.Request('GET', Uri.parse(url));
    req.maxRedirects = 10;
    if (headers != null) {
      req.headers.addAll(headers);
    }
    final httpResponse = await _httpClient.send(req);

    return HttpGetResponse(httpResponse);
  }
}

extension on FileResponse {
  Uri get uri => switch (this) {
        FileInfo(:final file) => file.uri,
        FileResponse(:final originalUrl) => Uri.parse(originalUrl),
      };
}
