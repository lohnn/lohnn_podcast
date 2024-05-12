import 'package:audio_service/audio_service.dart';
import 'package:flutter/widgets.dart';

class ChangePlayStateIntent extends Intent {
  final MediaAction state;

  const ChangePlayStateIntent(this.state);
}
