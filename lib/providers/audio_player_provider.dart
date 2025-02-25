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

      final subscription = _player.playbackState
          .map((e) => e.processingState)
          .distinct()
          .listen(_onPlaybackStateChange);
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
        loadNextEpisode(nextEpisode);
        state = AsyncData(await _getStatusForEpisode(nextEpisode));
      } else {
        state = const AsyncData(null);
      }
    } else {
      state = const AsyncData(null);
    }
  }

  Future<void> loadNextEpisode(Episode episode, {bool autoPlay = false}) async {
    await for (final fileResponse
        in ref.read(episodeLoaderProvider(episode).notifier).tryDownload()) {
      // TODO: This will be called multiple times if the episode is not
      //  downloaded. Potentially causing the player to load the episode when
      //  another is already playing. - We need to stop the player from
      //  restarting the episode if another has started playing.F
      await _player.loadEpisode(
        episode,
        episodeUri: fileResponse.currentUri,
        autoPlay: autoPlay,
      );
    }
  }

  Future<EpisodeWithStatus> _getStatusForEpisode(Episode episode) async {
    final status =
        await Repository()
            .get<UserEpisodeStatus>(query: Query.where('episodeId', episode.id))
            .firstOrNull;
    return EpisodeWithStatus(episode: episode, status: status);
  }

  Future<void> _onPlaybackStateChange(
    AudioProcessingState playbackState,
  ) async {
    if (playbackState == AudioProcessingState.completed) {
      final episodeWithStatus = await future;
      await _player.stop();

      // Set listened to true in episode
      final status = episodeWithStatus!.status.copyWith(isPlayed: true);
      await Repository().upsert<UserEpisodeStatus>(status);

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
  }

  Future<void> playEpisode(Episode episode, {bool autoPlay = true}) async {
    final status = await _getStatusForEpisode(episode);
    state = AsyncData(status);

    ref.read(playlistPodProvider.notifier).addToTopOfQueue(episode);

    loadNextEpisode(episode, autoPlay: true);

    if (autoPlay) _player.play();
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
