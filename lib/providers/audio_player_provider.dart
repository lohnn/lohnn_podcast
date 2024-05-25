import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:podcast/data/episode.dart';
import 'package:podcast/extensions/episode_snapshot_extension.dart';
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
      // androidNotificationOngoing: true,
      androidStopForegroundOnPause: false,
      androidNotificationIcon: 'drawable/podcast_icon_outline',
    ),
  );
}

@Riverpod(keepAlive: true)
class AudioPlayerPod extends _$AudioPlayerPod {
  late PodcastAudioHandler _player;

  @override
  Future<DocumentSnapshot<Episode>?> build() async {
    try {
      _player = await ref.watch(_audioPlayerProvider.future);

      final subscription = _player.playbackState.listen(_onPlaybackStateChange);
      ref.onDispose(subscription.cancel);

      // Initial setup of the queue
      ref
          .read(podcastUserPodProvider.selectAsync((e) => e.playQueue))
          .then(updateQueue);

      return future;
    } catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> updateQueue(Set<DocumentReference<Episode>> queue) async {
    if (queue.isNotEmpty) {
      final docs = await Future.wait([
        for (final episodeRef in queue) episodeRef.get(),
      ]);

      await _player.setQueue(
        [
          for (final snapshot in docs)
            if (snapshot.data() case final episode?)
              episode.mediaItem(snapshot),
        ],
      );

      state = AsyncData(docs.first);
    } else {
      state = const AsyncData(null);
    }
  }

  Future<void> _onPlaybackStateChange(PlaybackState playbackState) async {
    if (playbackState.processingState == AudioProcessingState.completed) {
      final episodeSnapshot = await future;
      await _player.stop();

      // TODO: Validate following logic is valid

      // Set listened to true in episode
      await episodeSnapshot!.markListened();

      // Remove episode reference from user
      final nextItem = await ref
          .read(podcastUserPodProvider.notifier)
          .removeFromQueue(episodeSnapshot.reference);

      // Start next episode from queue? (if not automatic)
      if (nextItem case final nextItem?) {
        playEpisode(await nextItem.get());
      } else {
        _player.clearPlaying();
      }
    }
  }

  Future<void> playEpisode(
    DocumentSnapshot<Episode> episodeSnapshot, {
    bool autoPlay = true,
  }) async {
    state = AsyncData(episodeSnapshot);

    ref
        .read(podcastUserPodProvider.notifier)
        .addToTopOfQueue(episodeSnapshot.reference);

    await _player.loadEpisode(episodeSnapshot, autoPlay: true);

    if (autoPlay) _player.play();
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
        MediaAction.skipToNext => _player.fastForward(),
        MediaAction.rewind => _player.rewind(),
        MediaAction.skipToPrevious => _player.rewind(),
        _ => throw UnsupportedError('Action $action not supported yet.')
      };

  void setPosition(int positionInMillis) {
    _player.seek(Duration(milliseconds: positionInMillis));
  }
}

@riverpod
Stream<({Duration position, Duration buffered, Duration? duration})>
    currentPosition(
  CurrentPositionRef ref,
) async* {
  final audioPlayer = await ref.watch(_audioPlayerProvider.future);
  yield* audioPlayer.positionStream;
}

@riverpod
Stream<PlaybackState> audioState(AudioStateRef ref) async* {
  final audioPlayer = await ref.watch(_audioPlayerProvider.future);
  yield* audioPlayer.playbackState;
}
