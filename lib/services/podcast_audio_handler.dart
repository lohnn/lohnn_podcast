import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast/data/episode.dart';

class PodcastAudioHandler extends BaseAudioHandler
    with SeekHandler, QueueHandler {
  final _player = AudioPlayer();
  final _playList = ConcatenatingAudioSource(children: []);

  /// Initialise our audio handler.
  PodcastAudioHandler() {
    // So that our clients (the Flutter UI and the system notification) know
    // what state to display, here we set up our audio handler to broadcast all
    // playback state changes as they happen via playbackState...
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  Future<Duration?> playEpisode(Episode episode) {
    mediaItem.add(episode.mediaItem);
    return _player.setAudioSource(
      AudioSource.uri(episode.url),
      initialPosition: episode.currentPosition,
    );
  }

  /// Transform a just_audio event into an audio_service state.
  ///
  /// This method is used from the constructor. Every event received from the
  /// just_audio player will be transformed into an audio_service state so that
  /// it can be broadcast to audio_service clients.
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      controls: [
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.rewind,
        const MediaControl(
          androidIcon: 'drawable/baseline_forward_30_24',
          label: 'Fast Forward',
          action: MediaAction.fastForward,
        ),
        MediaControl.custom(
          androidIcon: 'drawable/ic_baseline_favorite_24',
          label: 'favorite',
          name: 'favorite',
          extras: <String, dynamic>{'level': 1},
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
