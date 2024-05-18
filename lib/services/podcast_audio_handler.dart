import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/exceptions/document_not_found_exception.dart';
import 'package:rxdart/rxdart.dart';

class PodcastMediaItem extends MediaItem {
  final DocumentSnapshot<Episode> episode;

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
      final currentEpisodeSnapshot = mediaItem.valueOrNull?.episode;
      final currentEpisode = currentEpisodeSnapshot?.data();

      if ((currentEpisodeSnapshot, currentEpisode)
          case (final snapshot?, final episode?)) {
        snapshot.reference.set(
          episode.copyWith(currentPosition: position),
        );
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

  Future<void> setQueue(List<PodcastMediaItem> newQueue) async {
    await super.updateQueue(newQueue);
    await loadEpisode(newQueue.first.episode);
  }

  Future<void> loadEpisode(
    DocumentSnapshot<Episode> episodeSnapshot, {
    bool autoPlay = false,
  }) async {
    if (episodeSnapshot.data() case final episode?) {
      _stopPositionStream();
      final duration = await _player.setAudioSource(
        AudioSource.uri(episode.url),
        initialPosition: episode.currentPosition,
      );
      mediaItem.add(
        episode.mediaItem(episodeSnapshot, actualDuration: duration),
      );

      if (autoPlay) await _player.play();
      _startPositionStream();
    } else {
      return Future.error(DocumentNotFoundException(episodeSnapshot));
    }
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
          action: MediaAction.fastForward,
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
