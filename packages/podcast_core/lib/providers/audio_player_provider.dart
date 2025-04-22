import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:podcast_core/data/episode.model.dart';
import 'package:podcast_core/data/episode_with_status.dart';
import 'package:podcast_core/providers/app_lifecycle_state_provider.dart';
import 'package:podcast_core/providers/episode_loader_provider.dart';
import 'package:podcast_core/providers/playlist_pod_provider.dart';
import 'package:podcast_core/repository.dart';
import 'package:podcast_core/services/podcast_audio_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'audio_player_provider.g.dart';

@Riverpod(keepAlive: true)
Future<PodcastAudioHandler> _podcastAudioHandler(
  _PodcastAudioHandlerRef ref,
) async {
  final audioSession = await AudioSession.instance;
  await audioSession.configure(const AudioSessionConfiguration.speech());
  return PodcastAudioHandler(
    audioSession: audioSession,
    repository: ref.watch(repositoryProvider),
  );
}

@Riverpod(keepAlive: true)
class _AudioServicePod extends _$AudioServicePod {
  @override
  Future<PodcastAudioHandler> build() {
    return _initService();
  }

  Future<PodcastAudioHandler> _initService() async {
    final podcastAudioHandler = await ref.watch(
      _podcastAudioHandlerProvider.future,
    );

    return AudioService.init(
      builder: () => podcastAudioHandler,
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'se.lohnn.podcast.audio',
        androidNotificationChannelName: 'Lohnn Podcast',
        // @TODO: These two settings can cause the operating system to kill the app
        androidNotificationOngoing: true,
        // androidStopForegroundOnPause: false,
        androidNotificationIcon: 'drawable/podcast_icon_outline',
      ),
    );
  }
}

@Riverpod(keepAlive: true)
class AudioPlayerPod extends _$AudioPlayerPod {
  late PodcastAudioHandler _player;
  late Repository _repository;

  final _log = Logger('se.lohnn.podcast.AudioPlayerPod');

  @override
  Future<EpisodeWithStatus?> build() async {
    try {
      _player = await ref.watch(_audioServicePodProvider.future);
      _repository = ref.watch(repositoryProvider);

      final subscription = _player.episodeFinished.listen((_) {
        _onEpisodeFinished();
      });
      ref.onDispose(subscription.cancel);

      // Initial setup of the queue
      ref.listen(playlistPodProvider, (oldState, newState) {
        final queue = newState.valueOrNull ?? [];
        updateQueue(queue);
      });
      // ref.read(playlistPodProvider.future).then(updateQueue);

      ref.listen(appLifecycleStatePodProvider, (_, state) {
        if (state == AppLifecycleState.paused) {
          timeStopPlaying();
        }
      });

      return future;
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> updateQueue(List<Episode> queue) async {
    if (queue.isNotEmpty) {
      await _player.setQueue(queue);

      final nextEpisode = queue.firstOrNull;
      if (nextEpisode != null) {
        await loadNextEpisode(nextEpisode);
        state = AsyncData(await _getStatusForEpisode(nextEpisode));
      } else {
        state = const AsyncData(null);
      }
    } else {
      state = const AsyncData(null);
    }
  }

  StreamSubscription<EpisodeFileResponse>? _downloadSubscription;

  /// Loads the next episode in the queue and starts playing it.
  ///
  /// If [autoPlay] is set to true, the episode will start playing immediately.
  /// If [autoPlay] is set to false, the episode will be loaded but not played.
  ///
  /// It will check for already downloaded episodes and start playing it. If
  /// the episode is not downloaded, it will start downloading it.
  ///
  /// Returns a future that completes when the episode has been loaded from the
  /// first source.
  Future<void> loadNextEpisode(Episode episode, {bool autoPlay = false}) {
    _downloadSubscription?.cancel();

    final completer = Completer<void>();

    _downloadSubscription = ref
        .read(episodeLoaderProvider(episode).notifier)
        .tryDownload()
        .doOnCancel(() {
          if (!completer.isCompleted) {
            completer.complete();
          }
        })
        .listen(
          (fileResponse) async {
            await _player.loadEpisode(
              episode,
              episodeUri: fileResponse.currentUri,
              autoPlay: autoPlay,
            );

            if (!completer.isCompleted) {
              completer.complete();
            }
          },
          onError: (e, stackTrace) {
            if (!completer.isCompleted) {
              completer.complete();
            }
          },
          onDone: () {
            if (!completer.isCompleted) {
              completer.complete();
            }
          },
        );

    return completer.future;
  }

  Future<EpisodeWithStatus?> _getStatusForEpisode(Episode episode) async {
    final status = await _repository.getUserEpisodeStatus(episode.id);
    if(status == null) return null;
    return EpisodeWithStatus(episode: episode, status: status);
  }

  Future<void> _onEpisodeFinished() async {
    final episodeWithStatus = await future;

    _log.fine('Episode finished: ${episodeWithStatus?.episode.title}');

    await _player.stop();

    // Set listened to true in episode
    await _repository.markEpisodeListened(episodeWithStatus!);

    // Remove episode reference from user
    final nextItem = await ref
        .read(playlistPodProvider.notifier)
        .removeFromQueue(episodeWithStatus.episode);

    // Start next episode from queue? (if not automatic)
    if (nextItem case final nextItem?) {
      await playEpisode(nextItem);
    } else {
      _player.clearPlaying();
      state = const AsyncData(null);
    }
  }

  Future<void> playEpisode(Episode episode, {bool autoPlay = true}) async {
    final status = await _getStatusForEpisode(episode);
    state = AsyncData(status);

    await ref.read(playlistPodProvider.notifier).addToTopOfQueue(episode);

    await loadNextEpisode(episode, autoPlay: autoPlay);

    if (autoPlay) await _player.play();
  }

  void triggerMediaAction(MediaAction action) => switch (action) {
    MediaAction.playPause =>
      switch (_player.playbackState.valueOrNull?.playing ?? false) {
        true => _player.pause(),
        false => _player.play(),
      },
    MediaAction.play => _player.play(),
    MediaAction.pause => _player.pause(),
    MediaAction.stop => _player.stop(),
    MediaAction.fastForward => _player.fastForward(),
    MediaAction.skipToNext => _player.fastForward(),
    MediaAction.rewind => _player.rewind(),
    MediaAction.skipToPrevious => _player.rewind(),
    _ => throw UnsupportedError('Action $action not supported yet.'),
  };

  void seekRelative(Duration offset) {
    _player.seekRelative(offset);
  }

  void setPosition(int positionInMillis) {
    _player.seek(Duration(milliseconds: positionInMillis));
  }

  /// Stops the player and disposes stream after delay if the player is not
  /// playing.
  void timeStopPlaying() {
    if (_player.isPlaying) return;
    _player.timeStop();
  }

  Future<void> dispose() => _player.dispose();
}

@riverpod
Stream<({Duration position, Duration buffered, Duration? duration})>
currentPosition(CurrentPositionRef ref) async* {
  final audioPlayer = await ref.watch(_audioServicePodProvider.future);
  yield* audioPlayer.positionStream;
}

@riverpod
Stream<PlaybackState> audioState(AudioStateRef ref) async* {
  final audioPlayer = await ref.watch(_audioServicePodProvider.future);
  yield* audioPlayer.playbackState;
}
