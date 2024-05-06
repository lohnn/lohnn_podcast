import 'package:cloud_firestore/cloud_firestore.dart';
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
    QueryDocumentSnapshot<Episode> episodeSnapshot,
  ) async {
    await _player.setUrl(
      episodeSnapshot.data().url,
      initialPosition: episodeSnapshot.data().currentPosition,
    );
    _player.play();
    state = episodeSnapshot.data();
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
Stream<bool> audioPlaying(AudioPlayingRef ref) async* {
  final audioPlayer = ref.watch(_audioPlayerProvider);
  audioPlayer.playing;
  yield* audioPlayer.playingStream;
}
