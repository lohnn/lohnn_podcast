import 'dart:async';

import 'package:async/async.dart';
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

  double get currentDownloadProgress;
}

final class RemoteEpisodeFile extends EpisodeFileResponse {
  const RemoteEpisodeFile({required super.remoteUri});

  @override
  String toString() {
    return 'RemoteEpisodeFile(remoteUri: $remoteUri)';
  }

  @override
  double get currentDownloadProgress => 0;
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

  @override
  double get currentDownloadProgress => progress * 100;
}

final class LocalEpisodeFile extends EpisodeFileResponse {
  final Uri localUri;

  @override
  Uri get currentUri => localUri;

  const LocalEpisodeFile({required super.remoteUri, required this.localUri});

  @override
  String toString() {
    return 'LocalEpisodeFile(remoteUri: $remoteUri, localUri: $localUri)';
  }

  @override
  double get currentDownloadProgress => 100;
}

@riverpod
class EpisodeLoader extends _$EpisodeLoader {
  static final _cacheManager = EpisodeCacheManager();

  @override
  Future<EpisodeFileResponse> build(Episode episode) async {
    ref.keepAlive();
    final localFile = await _cacheManager.getFileFromCache(episode);
    if (localFile != null) {
      return localFile;
    } else {
      return _cacheManager.getCurrentStatus(episode) ??
          RemoteEpisodeFile(remoteUri: episode.url.uri);
    }
  }

  /// Downloads the episode and returns the URI to the file.
  ///
  /// During download, the uri will report the original URL of the episode.
  Stream<EpisodeFileResponse> tryDownload() async* {
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
    final controller = BehaviorSubject<EpisodeFileResponse>();

    final tempDuringDownloadFile = destination.parent.childFile(
      '${destination.basename}.download',
    );

    _dio
        .downloadUri(
      episode.url.uri,
      tempDuringDownloadFile.path,
      options: Options(responseType: ResponseType.stream, maxRedirects: 10),
      onReceiveProgress: (received, total) {
        controller.add(
          DownloadingEpisodeFile(
            remoteUri: episode.url.uri,
            progress: received / total,
          ),
        );
      },
    )
        .then(
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
        if ((error, stackTrace) case (
        final Object error,
        final StackTrace stackTrace,
        )) {
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
    return _instance = EpisodeCacheManager._(
      episodeFileService: EpisodeFileService(),
    );
  }

  EpisodeCacheManager._({required this.episodeFileService});

  final EpisodeFileService episodeFileService;

  final Map<Episode, BehaviorSubject<EpisodeFileResponse>> _downloads = {};

  final _applicationCacheDirectoryMemoizer = AsyncMemoizer<Directory>();

  /// The directory where the episodes are stored.
  ///
  /// Also makes sure to clean up the directory before returning it.
  Future<Directory> get applicationCacheDirectory {
    return _applicationCacheDirectoryMemoizer.runOnce(() async {
      final dir = await const LocalFileSystem()
          .directory(await getApplicationCacheDirectory())
          .childDirectory('episodes')
          .create(recursive: true);

      // Clean up old files
      final files = await dir.list().toList();
      for (final file in files) {
        if (file case final File file) {
          if (file.path.endsWith('.download')) {
            await file.delete();
          } else if ((await FileStat.stat(file.path)).accessed
          // @TODO: This logic should be improved somewhow
          //  Maybe we should look at the queue and remove files that are not in the queue?
              .isBefore(DateTime.now().subtract(const Duration(days: 5)))) {
            await file.delete();
          }
        }
      }

      return dir;
    });
  }

  Future<File> _fileFromEpisode(Episode episode) async {
    return (await applicationCacheDirectory).childFile(episode.localFilePath);
  }

  Future<LocalEpisodeFile?> getFileFromCache(Episode episode) async {
    final file = (await applicationCacheDirectory).childFile(
      episode.localFilePath,
    );

    if (await file.exists()) {
      return LocalEpisodeFile(remoteUri: episode.url.uri, localUri: file.uri);
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

    final file = (await applicationCacheDirectory).childFile(
      episode.localFilePath,
    );

    if (await file.exists()) {
      yield LocalEpisodeFile(remoteUri: episode.url.uri, localUri: file.uri);
      return;
    }

    // The get function is closing the sink
    // ignore: close_sinks
    final subject =
    _downloads[episode] = episodeFileService.get(
      episode,
      await _fileFromEpisode(episode),
    );

    yield* subject.stream;
  }
}
