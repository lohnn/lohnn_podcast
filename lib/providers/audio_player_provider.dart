import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flutter/foundation.dart';
import 'package:podcast/brick/repository.dart';
import 'package:podcast/data/episode.model.dart';
import 'package:podcast/data/episode_with_status.dart';
import 'package:podcast/data/user_episode_status.model.dart';
import 'package:podcast/extensions/future_extensions.dart';
import 'package:podcast/providers/app_lifecycle_state_provider.dart';
import 'package:podcast/providers/episode_loader_provider.dart';
import 'package:podcast/providers/playlist_pod_provider.dart';
import 'package:podcast/services/podcast_audio_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_player_provider.g.dart';

@Riverpod(keepAlive: true)
Future<PodcastAudioHandler> _podcastAudioHandler(
  _PodcastAudioHandlerRef ref,
) async {
  final audioSession = await AudioSession.instance;
  await audioSession.configure(const AudioSessionConfiguration.speech());
  return PodcastAudioHandler(audioSession: audioSession);
}

@Riverpod(keepAlive: true)
class _AudioServicePod extends _$AudioServicePod {
  @override
  Future<PodcastAudioHandler> build() async {
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

  @override
  Future<EpisodeWithStatus?> build() async {
    try {
      _player = await ref.watch(_audioServicePodProvider.future);

      final subscription = _player.playbackState.listen(_onPlaybackStateChange);
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

  // TODO: Updates to queue (without playing) does not trigger this
  Future<void> updateQueue(List<Episode> queue) async {
    if (queue.isNotEmpty) {
      final statuses =
          await [for (final episode in queue) _getForEpisode(episode)].wait;
      await _player.setQueue([for (final status in statuses) status]);

      final nextEpisode = statuses.firstOrNull;
      if (nextEpisode != null) {
        loadNextEpisode(nextEpisode);
      }

      state = AsyncData(nextEpisode);
    } else {
      state = const AsyncData(null);
    }
  }

  Future<void> loadNextEpisode(
    EpisodeWithStatus episodeWithStatus, {
    bool autoPlay = false,
  }) async {
    // TODO: Check if this is cancelled correctly when changing during download
    await for (final fileResponse in ref
        .read(episodeLoaderProvider(episodeWithStatus.episode).notifier)
        .tryDownload()) {
      await _player.loadEpisode(
        episodeWithStatus,
        episodeUri: fileResponse.currentUri,
        autoPlay: autoPlay,
      );
    }
  }

  Future<EpisodeWithStatus> _getForEpisode(Episode episode) async {
    final status = await Repository()
        .get<UserEpisodeStatus>(query: Query.where('episodeId', episode.id))
        .firstOrNull;
    return EpisodeWithStatus(
      episode: episode,
      // TODO: Implement
      playingFromDownloaded: false,
      status: status,
    );
  }

  Future<void> _onPlaybackStateChange(PlaybackState playbackState) async {
    if (playbackState.processingState == AudioProcessingState.completed) {
      final episodeWithStatus = await future;
      await _player.stop();

      // TODO: Validate following logic is valid

      // Set listened to true in episode
      final status = episodeWithStatus!.status.copyWith(isPlayed: true);
      await Repository().upsert<UserEpisodeStatus>(status);

      // Remove episode reference from user
      final nextItem = await ref
          .read(playlistPodProvider.notifier)
          .removeFromQueue(episodeWithStatus.episode);

      // Start next episode from queue? (if not automatic)
      if (nextItem case final nextItem?) {
        playEpisode(nextItem);
      } else {
        _player.clearPlaying();
        state = const AsyncData(null);
      }
    }
  }

  Future<void> playEpisode(
    Episode episode, {
    bool autoPlay = true,
  }) async {
    final status = await _getForEpisode(episode);
    state = AsyncData(status);

    ref.read(playlistPodProvider.notifier).addToTopOfQueue(episode);

    loadNextEpisode(status, autoPlay: true);

    if (autoPlay) _player.play();
  }

  void triggerMediaAction(MediaAction action) => switch (action) {
        MediaAction.playPause => switch (
              _player.playbackState.valueOrNull?.playing ?? false) {
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
        _ => throw UnsupportedError('Action $action not supported yet.')
      };

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
    currentPosition(
  CurrentPositionRef ref,
) async* {
  final audioPlayer = await ref.watch(_audioServicePodProvider.future);
  yield* audioPlayer.positionStream;
}

@riverpod
Stream<PlaybackState> audioState(AudioStateRef ref) async* {
  final audioPlayer = await ref.watch(_audioServicePodProvider.future);
  yield* audioPlayer.playbackState;
}
