import 'package:just_audio/just_audio.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/intents/play_pause_intent.dart';
import 'package:podcast/providers/firebase/firestore/podcast_user_pod_provider.dart';
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
  Stream<Episode?> build() async* {
    _player = ref.watch(_audioPlayerProvider);

    final user = ref.watch(podcastUserPodProvider).valueOrNull;
    if (user?.playQueue case final episodeQueue? when episodeQueue.isNotEmpty) {
      final episode = (await episodeQueue.first.get()).data();

      yield episode;

      if (episode case final episode?) {
        await _player.setUrl(
          episode.url,
          initialPosition: episode.currentPosition,
        );
      }
    }
  }

  Future<void> playEpisode(
    Episode episodeSnapshot,
  ) async {
    state = AsyncData(episodeSnapshot);
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

  void setPosition(int positionInMillis) {
    _player.seek(Duration(milliseconds: positionInMillis));
  }

  // ignore: avoid_public_notifier_properties
  Duration? get currentEpisodeDuration => state.valueOrNull?.duration;
}

@riverpod
Stream<Duration?> currentPosition(CurrentPositionRef ref) async* {
  final audioPlayer = ref.watch(_audioPlayerProvider);
  yield audioPlayer.position;
  yield* audioPlayer.positionStream;
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
