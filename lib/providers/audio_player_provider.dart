import 'package:just_audio/just_audio.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/intents/play_pause_intent.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_player_provider.g.dart';

@Riverpod(keepAlive: true)
AudioPlayer _audioPlayer(_AudioPlayerRef ref) {
  ref.onDispose(() => ref.state.dispose());
  return AudioPlayer();
}

@Riverpod(keepAlive: true)
class AudioPlayerPod extends _$AudioPlayerPod {
  late AudioPlayer _player;

  @override
  Episode? build() {
    _player = ref.watch(_audioPlayerProvider);
    // TODO: Pick up the last played episode from the user
    return null;
  }

  Future<void> playEpisode(
    Episode episodeSnapshot,
  ) async {
    state = episodeSnapshot;
    await _player.setUrl(
      episodeSnapshot.url,
      initialPosition: episodeSnapshot.currentPosition,
    );
    _player.play();
  }

  void changePlayState(PlayState state) => switch (state) {
        PlayState.toggle => switch (_player.playing) {
            true => _player.pause(),
            false => _player.play(),
          },
        PlayState.play => _player.play(),
        PlayState.pause => _player.pause(),
        PlayState.stop => _player.stop(),
      };
}

@riverpod
Stream<Duration?> currentPosition(CurrentPositionRef ref) async* {
  final audioPlayer = ref.watch(_audioPlayerProvider);
  yield audioPlayer.duration;
  yield* audioPlayer.durationStream;
}

@riverpod
Stream<Duration?> bufferedPosition(BufferedPositionRef ref) async* {
  final audioPlayer = ref.watch(_audioPlayerProvider);
  yield audioPlayer.bufferedPosition;
  yield* audioPlayer.bufferedPositionStream;
}

@riverpod
Stream<PlayerState> audioState(AudioStateRef ref) async* {
  final audioPlayer = ref.watch(_audioPlayerProvider);
  yield audioPlayer.playerState;
  yield* audioPlayer.playerStateStream;
}
