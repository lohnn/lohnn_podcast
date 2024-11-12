import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast/brick/repository.dart';
import 'package:podcast/data/episode.model.dart';
import 'package:podcast/data/episode_with_status.dart';
import 'package:podcast/data/serdes/duration_model.dart';
import 'package:podcast/data/user_episode_status.model.dart';
import 'package:podcast/extensions/future_extensions.dart';
import 'package:rxdart/rxdart.dart';

class PodcastMediaItem extends MediaItem {
  final EpisodeWithStatus episode;

  PodcastMediaItem({
    required this.episode,
    required super.id,
    required super.title,
    required super.artUri,
    required super.duration,
  });
}

class PodcastAudioHandler extends BaseAudioHandler
    with SeekHandler, QueueHandler {
  final _player = AudioPlayer();
  final AudioSession audioSession;

  @override
  // ignore: overridden_fields
  final BehaviorSubject<PodcastMediaItem?> mediaItem =
      BehaviorSubject.seeded(null);

  Stream<({Duration position, Duration buffered, Duration? duration})>
      get positionStream => Rx.combineLatest3(
            _player.positionStream,
            _player.bufferedPositionStream,
            _player.durationStream,
            (a, b, c) => (position: a, buffered: b, duration: c),
          );

  /// Initialise our audio handler.
  PodcastAudioHandler({required this.audioSession}) {
    // So that our clients (the Flutter UI and the system notification) know
    // what state to display, here we set up our audio handler to broadcast all
    // playback state changes as they happen via playbackState...
    // @TODO: Can we send current position updates to [playbackState]
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  StreamSubscription<Duration>? _positionSubscription;

  void _stopPositionStream() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  void _startPositionStream() {
    _stopPositionStream();
    _positionSubscription = _player.positionStream
        .throttleTime(const Duration(seconds: 10), trailing: true)
        .listen((
      position,
    ) {
      final currentEpisodeStatus = mediaItem.valueOrNull?.episode;

      if (currentEpisodeStatus case final currentEpisodeStatus?) {
        final status = switch (currentEpisodeStatus.status) {
          // Just in case we never created a status (shouldn't happen)
          null => UserEpisodeStatus(
              episodeId: currentEpisodeStatus.episode.id,
              isPlayed: false,
              currentPosition: DurationModel(position),
            ),
          final status => status.copyWith(isPlayed: true),
        };
        Repository().upsert<UserEpisodeStatus>(status);
      }
    });
  }

  @override
  Future<void> play() async {
    await audioSession.setActive(true);
    return _player.play();
  }

  @override
  Future<void> pause() async {
    await audioSession.setActive(false);
    return _player.pause();
  }

  @override
  Future<void> stop() async {
    await audioSession.setActive(false);
    return _player.stop();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> setQueue(List<EpisodeWithStatus> newQueue) async {
    await super.updateQueue([
      for (final status in newQueue) status.mediaItem(),
    ]);
    await loadEpisode(newQueue.first);
  }

  Future<void> loadEpisode(
    EpisodeWithStatus status, {
    bool autoPlay = false,
  }) async {
    _stopPositionStream();

    final duration = await _player.setAudioSource(
      AudioSource.uri(status.episode.url.uri),
      initialPosition: status.status?.currentPosition.duration,
    );

    mediaItem.add(status.mediaItem(actualDuration: duration));

    if (autoPlay) await _player.play();
    _startPositionStream();
  }

  Future<EpisodeWithStatus> _getForEpisode(Episode episode) async {
    final status = await Repository()
        .get<UserEpisodeStatus>(query: Query.where('episodeId', episode.id))
        .firstOrNull;
    return EpisodeWithStatus(episode: episode, status: status);
  }

  void clearPlaying() {
    mediaItem.add(null);
  }

  /// Transform a just_audio event into an audio_service state.
  ///
  /// This method is used from the constructor. Every event received from the
  /// just_audio player will be transformed into an audio_service state so that
  /// it can be broadcast to audio_service clients.
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        const MediaControl(
          androidIcon: 'drawable/baseline_replay_10_24',
          label: 'Rewind',
          action: MediaAction.rewind,
        ),
        if (_player.playing) MediaControl.pause else MediaControl.play,
        const MediaControl(
          androidIcon: 'drawable/baseline_forward_10_24',
          label: 'Fast Forward',
          action: MediaAction.fastForward,
        ),
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
        MediaAction.skipToNext,
        MediaAction.rewind,
        MediaAction.fastForward,
      },
      processingState: switch (_player.processingState) {
        ProcessingState.idle => AudioProcessingState.idle,
        ProcessingState.loading => AudioProcessingState.loading,
        ProcessingState.buffering => AudioProcessingState.buffering,
        ProcessingState.ready => AudioProcessingState.ready,
        ProcessingState.completed => AudioProcessingState.completed,
      },
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
