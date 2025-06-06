import 'package:flutter/widgets.dart';
import 'package:podcast_core/intents/play_pause_intent.dart';
import 'package:podcast_core/providers/audio_player_provider.dart';

class ChangePlayStateAction extends Action<ChangePlayStateIntent> {
  final AudioPlayerPod audioPlayer;

  ChangePlayStateAction(this.audioPlayer);

  @override
  void invoke(ChangePlayStateIntent intent) {
    audioPlayer.triggerMediaAction(intent.state);
  }
}
