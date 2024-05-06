import 'package:flutter/widgets.dart';

class ChangePlayStateIntent extends Intent {
  final PlayState state;

  const ChangePlayStateIntent(this.state);
}

enum PlayState {
  toggle,
  play,
  pause,
  stop,
  ;
}
