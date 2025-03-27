import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logging/logging.dart';
import 'package:podcast/brick/repository.dart';
import 'package:podcast/data/episode.model.dart';
import 'package:podcast/data/episode_with_status.dart';
import 'package:podcast/data/serdes/duration_model.dart';
import 'package:podcast/data/user_episode_status.model.dart';
import 'package:podcast/extensions/future_extensions.dart';
import 'package:rxdart/rxdart.dart';

class PodcastMediaItem extends MediaItem {
  final Episode episode;

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
  final log = Logger('se.lohnn.podcast.PodcastAudioHandler');

  final _player = AudioPlayer();
  final AudioSession audioSession;

  @override
  // Just an override to set the type of the BehaviorSubject to PodcastMediaItem.
  // ignore: overridden_fields
  final BehaviorSubject<PodcastMediaItem?> mediaItem = BehaviorSubject.seeded(
    null,
  );

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
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  StreamSubscription<Duration>? _positionSubscription;

  // @TODO: Revise this to use better logic
  Stream<void> get episodeFinished => playbackState
      .map((state) => state.processingState)
      .distinct()
      .where((processingState) {
        log.fine('Processing state: $processingState}');
        return processingState == AudioProcessingState.completed;
      })
      .map((_) {});

  void _stopPositionStream() {
    _positionSubscription?.cancel();
    _positionSubscription = null;
  }

  void _startPositionStream() {
    _stopPositionStream();

    log.fine(
      'Starting position stream for ${mediaItem.valueOrNull?.episode.title}',
    );
    _positionSubscription = _player.positionStream
        .throttleTime(
          const Duration(seconds: 10),
          leading: false,
          trailing: true,
        )
        .distinct()
        .listen((position) async {
          final currentEpisode = mediaItem.valueOrNull?.episode;
          log.fine(
            'Position: $position - Current episode: ${currentEpisode?.title}',
          );

          if (currentEpisode case final currentEpisode?) {
            await _sendPositionUpdate(
              episode: currentEpisode,
              position: position,
            );
          }
        });
  }

  Future<void> _sendPositionUpdate({
    required Episode episode,
    required Duration position,
  }) async {
    final status = await _getStatusForEpisode(episode);
    final newStatus = status.status.copyWith(
      currentPosition: DurationModel(position),
    );
    await Repository().upsert<UserEpisodeStatus>(newStatus);
  }

  bool get isPlaying => _player.playing;

  @override
  Future<void> play() async {
    await audioSession.setActive(true);
    _clearStopTimer();
    return _player.play();
  }

  Timer? _stopTimer;

  void _clearStopTimer() {
    _stopTimer?.cancel();
    _stopTimer = null;
  }

  @override
  Future<void> pause() async {
    await audioSession.setActive(false);

    // Stop the player after 5 minutes of inactivity to clear resources and
    // save battery
    _clearStopTimer();
    timeStop();

    return _player.pause();
  }

  @override
  Future<void> stop() async {
    await audioSession.setActive(false);
    _clearStopTimer();
    timeStop();
    return _player.stop();
  }

  /// Stop the player after 5 minutes of inactivity to clear resources and
  /// save battery.
  void timeStop() {
    _clearStopTimer();
    _stopTimer = Timer(const Duration(minutes: 15), stop);
  }

  Future<void> dispose() async {
    await audioSession.setActive(false);
    _clearStopTimer();
    return _player.dispose();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  Future<void> setQueue(List<Episode> newQueue) async {
    await super.updateQueue([
      for (final episode in newQueue) episode.mediaItem(),
    ]);
  }

  Future<void> loadEpisode(
    Episode episode, {
    required Uri episodeUri,
    bool autoPlay = false,
  }) async {
    // If the player is already playing the same file, don't reload it.
    if (_player.audioSource case UriAudioSource(
      :final uri,
    ) when uri == episodeUri) {
      if (autoPlay) await play();
      return;
    }

    _stopPositionStream();
    final status = await _getStatusForEpisode(episode);

    final seekToPosition = status.status.currentPosition.duration;
    log.fine('Loading episode: ${episode.title} - $seekToPosition');

    final duration = await _player.setAudioSource(
      AudioSource.uri(episodeUri),
      initialPosition: seekToPosition,
    );

    mediaItem.add(
      episode.mediaItem(
        actualDuration: duration,
        isPlayingFromDownloaded: episodeUri.scheme == 'file',
      ),
    );

    // If the episode is almost finished, rewind 10 seconds.
    if (duration ?? episode.duration?.duration case final episodeDuration?
        when seekToPosition.inSeconds > episodeDuration.inSeconds - 10) {
      await _player.seek(episodeDuration - const Duration(seconds: 10));
    } else {
      // Seek to the last known position of the episode.
      await _player.seek(seekToPosition);
    }

    // If the player was playing (such as when an episode has finished),
    // continue playing this new episode.
    if (autoPlay || isPlaying) await play();
    _startPositionStream();
  }

  // @TODO: This is duplicated with [AudioPlayerPod._getStatusForEpisode]
  Future<EpisodeWithStatus> _getStatusForEpisode(Episode episode) async {
    final status =
        await Repository()
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
      updateTime: event.updateTime,
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
      androidCompactActionIndices: const [0, 1, 2],
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
