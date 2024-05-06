import 'package:flutter/widgets.dart';
import 'package:podcast/intents/play_pause_intent.dart';
import 'package:podcast/providers/audio_player_provider.dart';

class PlayPauseAction extends Action<ChangePlayStateIntent> {
  final AudioPlayerPod audioPlayer;

  PlayPauseAction(this.audioPlayer);

  @override
  void invoke(ChangePlayStateIntent intent) {
    audioPlayer.changePlayState(intent.state);
  }
}
