import 'dart:async';

import 'package:dio/dio.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:path_provider/path_provider.dart';
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
  
  @override
  String toString() {
    return 'RemoteEpisodeFile(remoteUri: $remoteUri)';
  }
}

final class DownloadingEpisodeFile extends EpisodeFileResponse {
  final double progress;

  const DownloadingEpisodeFile({
    required super.remoteUri,
    required this.progress,
  });
  
  @override
  String toString() {
    return 'DownloadingEpisodeFile(remoteUri: $remoteUri, progress: $progress)';
  }
}

final class LocalEpisodeFile extends EpisodeFileResponse {
  final Uri localUri;

  @override
  Uri get currentUri => localUri;

  const LocalEpisodeFile({
    required super.remoteUri,
    required this.localUri,
  });
  
  @override
  String toString() {
    return 'LocalEpisodeFile(remoteUri: $remoteUri, localUri: $localUri)';
  }
}

@riverpod
class EpisodeLoader extends _$EpisodeLoader {
  static final _cacheManager = EpisodeCacheManager();

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

    await for (final fileResponse in _cacheManager.download(episode)) {
      state = AsyncData(fileResponse);
      yield fileResponse;
    }
  }
}

class EpisodeFileService {
  factory EpisodeFileService() => EpisodeFileService._(Dio());

  const EpisodeFileService._(this._dio);

  final Dio _dio;

  BehaviorSubject<EpisodeFileResponse> get(Episode episode, File destination) {
    // TODO: Make sure to always close the subject when done, even if an error occurs
    final controller = BehaviorSubject<EpisodeFileResponse>();

    final tempDuringDownloadFile = destination.parent.childFile(
      '${destination.basename}.download',
    );

    final response = _dio.downloadUri(
      episode.url.uri,
      tempDuringDownloadFile.path,
      options: Options(
        responseType: ResponseType.stream,
      ),
      onReceiveProgress: (received, total) {
        controller.add(
          DownloadingEpisodeFile(
            remoteUri: episode.url.uri,
            progress: received / total,
          ),
        );
      },
    ).then(
      (response) {
        tempDuringDownloadFile.renameSync(destination.path);
        controller.add(
          LocalEpisodeFile(
            remoteUri: episode.url.uri,
            localUri: destination.uri,
          ),
        );
        controller.close();
      },
      onError: (error, stackTrace) {
        if ((error, stackTrace)
            case (final Object error, final StackTrace stackTrace)) {
          controller.addError(error, stackTrace);
        }
        controller.close();
      },
    );

    return controller;
  }
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
      episodeFileService: EpisodeFileService(),
    );
  }

  EpisodeCacheManager._({
    required this.fileSystem,
    required this.episodeFileService,
  });

  final FileSystem fileSystem;

  final EpisodeFileService episodeFileService;

  final Map<Episode, BehaviorSubject<EpisodeFileResponse>> _downloads = {};

  Future<File> _fileFromEpisode(Episode episode) async {
    final cacheDirectory = const LocalFileSystem().directory(
      await getApplicationCacheDirectory(),
    );
    // TODO: Use episode safeId instead of URL
    //  Maybe together with the podcast ID
    return cacheDirectory.childFile(episode.url.uri.pathSegments.last);
  }

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

    // The get function is closing the sink
    // ignore: close_sinks
    final subject = _downloads[episode] = episodeFileService.get(
      episode,
      await _fileFromEpisode(episode),
    );

    yield* subject.stream;
  }
}
