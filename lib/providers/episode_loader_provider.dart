import 'dart:async';

import 'package:dio/dio.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:podcast/data/episode.model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

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
  static const _cacheManager = EpisodeCacheManager();

  @override
  Future<EpisodeFileResponse> build(Episode episode) async {
    final localFile = await _cacheManager.getFileFromCache(
      episode,
    );
    if (localFile != null) {
      return localFile;
    } else {
      // TODO: Somehow check if currently downloading and return [DownloadingEpisodeFile]
      _cacheManager.getCurrentStatus(episode);
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

    await for (final fileResponse in _cacheManager.download(
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
  factory EpisodeFileService() => EpisodeFileService._(Dio());

  const EpisodeFileService._(this._dio);

  final Dio _dio;

  @override
  BehaviorSubject<EpisodeFileResponse> get(Episode episode) {
    // TODO: Make sure to always close the subject when done, even if an error occurs
    final controller = BehaviorSubject<EpisodeFileResponse>();

    final response = _dio.downloadUri<ResponseBody>(
      episode.url.uri,
      episode.url.uri.pathSegments.last,
      options: Options(
        responseType: ResponseType.stream,
      ),
    );

    final req = http.Request('GET', Uri.parse(url));
    req.maxRedirects = 10;
    if (headers != null) {
      req.headers.addAll(headers);
    }
    final httpResponse = await _httpClient.send(req);

    return controller;
  }
}

extension on FileResponse {
  Uri get uri => switch (this) {
        FileInfo(:final file) => file.uri,
        FileResponse(:final originalUrl) => Uri.parse(originalUrl),
      };
}

class EpisodeCacheManager {
  static EpisodeCacheManager? _instance;

  factory EpisodeCacheManager() {
    if (_instance case final instance?) {
      return instance;
    }
    // TODO: Cleanup old files
    return _instance = EpisodeCacheManager._(
      fileSystem: const LocalFileSystem(),
      episodeFileService: const EpisodeFileService(),
    );
  }

  EpisodeCacheManager._({
    required this.fileSystem,
    required this.episodeFileService,
  });

  final FileSystem fileSystem;

  final EpisodeFileService episodeFileService;

  final Map<Episode, BehaviorSubject<EpisodeFileResponse>> _downloads = {};

  Future<LocalEpisodeFile?> getFileFromCache(Episode episode) async {
    final file = fileSystem.file(
      episode.url.uri.pathSegments.last,
    );
    if (await file.exists()) {
      return LocalEpisodeFile(
        remoteUri: episode.url.uri,
        localUri: file.uri,
      );
    }
    return null;
  }

  EpisodeFileResponse? getCurrentStatus(Episode episode) {
    return _downloads[episode]?.valueOrNull;
  }

  Stream<EpisodeFileResponse> download(Episode episode) async* {
    if (_downloads[episode] case final controller?) {
      yield* controller.stream;
      return;
    }

    final file = fileSystem.file(
      episode.url.uri.pathSegments.last,
    );
    if (await file.exists()) {
      yield LocalEpisodeFile(
        remoteUri: episode.url.uri,
        localUri: file.uri,
      );
      return;
    }

    // TODO: Implement
    final subject = _downloads[episode] = episodeFileService.get(episode);

    yield* subject.stream;
  }
}
