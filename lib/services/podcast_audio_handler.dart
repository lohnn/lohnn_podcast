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

  Stream<({Duration position, Duration buffered})> get positionStream =>
      Rx.combineLatest2(
        _player.positionStream,
        _player.bufferedPositionStream,
        (a, b) => (position: a, buffered: b),
      );

  /// Initialise our audio handler.
  PodcastAudioHandler({required this.audioSession}) {
    // So that our clients (the Flutter UI and the system notification) know
    // what state to display, here we set up our audio handler to broadcast all
    // playback state changes as they happen via playbackState...
    // @TODO: Can we send current position updates to [playbackState]
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    _player.positionStream.throttleTime(const Duration(seconds: 10), trailing: true).forEach((
      position,
    ) {
      // @TODO: This is a bit of a hack, figure out if we can guard against this smarter
      // Sometimes on startup (when loading episode it seems) we get position
      // stream update and hence update the episode with currentPosition = 0,
      // resetting the episode for all devices.
      if (position.inSeconds <= 0) return;
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
      mediaItem.add(episode.mediaItem(episodeSnapshot));
      await _player.setAudioSource(
        AudioSource.uri(episode.url),
        initialPosition: episode.currentPosition,
      );
      if (autoPlay) await _player.play();
    } else {
      return Future.error(DocumentNotFoundException(episodeSnapshot));
    }
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
      },
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[_player.processingState]!,
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }
}
