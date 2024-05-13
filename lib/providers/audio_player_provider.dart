import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/providers/firebase/firestore/podcast_user_pod_provider.dart';
import 'package:podcast/services/podcast_audio_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'audio_player_provider.g.dart';

@Riverpod(keepAlive: true)
Future<PodcastAudioHandler> _audioPlayer(_AudioPlayerRef ref) async {
  final audioSession = await AudioSession.instance;
  await audioSession.configure(const AudioSessionConfiguration.speech());

  return await AudioService.init(
    builder: () => PodcastAudioHandler(audioSession: audioSession),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'se.lohnn.podcast.audio',
      androidNotificationChannelName: 'Lohnn Podcast',
      // @TODO: These two settings can cause the operating system to kill the app
      androidNotificationOngoing: true,
      // androidStopForegroundOnPause: true,
      androidNotificationIcon: 'drawable/podcast_icon_outline',
    ),
  );
}

@Riverpod(keepAlive: true)
class AudioPlayerPod extends _$AudioPlayerPod {
  late PodcastAudioHandler _player;

  @override
  Stream<Episode?> build() async* {
    try {
      _player = await ref.watch(_audioPlayerProvider.future);

      final user = ref.read(podcastUserPodProvider).valueOrNull;
      if (user?.playQueue case final episodeQueue?
          when episodeQueue.isNotEmpty) {
        final episode = await episodeQueue.first.get();

        yield episode.data();

        if (episode case final episode) {
          await _player.loadEpisode(episode);
        }
      }
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> playEpisode(
    DocumentSnapshot<Episode> episodeSnapshot,
  ) async {
    state = AsyncData(episodeSnapshot.data());

    ref
        .read(podcastUserPodProvider.notifier)
        .addToTopOfQueue(episodeSnapshot.reference);

    await _player.loadEpisode(episodeSnapshot, autoPlay: true);
    _player.play();
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
        MediaAction.rewind => _player.rewind(),
        _ => throw UnsupportedError('Action $action not supported yet.')
      };

  void setPosition(int positionInMillis) {
    _player.seek(Duration(milliseconds: positionInMillis));
  }

  // ignore: avoid_public_notifier_properties
  Duration? get currentEpisodeDuration => state.valueOrNull?.duration;
}

@riverpod
Stream<({Duration position, Duration buffered})> currentPosition(
    CurrentPositionRef ref) async* {
  final audioPlayer = await ref.watch(_audioPlayerProvider.future);
  yield* audioPlayer.positionStream;
}

@riverpod
Stream<PlaybackState> audioState(AudioStateRef ref) async* {
  final audioPlayer = await ref.watch(_audioPlayerProvider.future);
  yield* audioPlayer.playbackState;
}
