import 'dart:ui' as ui;

import 'package:riverpod_annotation/riverpod_annotation.dart';

export 'dart:ui' show AppLifecycleState;

part 'app_lifecycle_state_provider.g.dart';

@Riverpod(keepAlive: true)
class AppLifecycleStatePod extends _$AppLifecycleStatePod {
  @override
  ui.AppLifecycleState build() {
    return ui.AppLifecycleState.resumed;
  }

  set lifecycleState(ui.AppLifecycleState newState) => state = newState;

  void close() {
    state = ui.AppLifecycleState.paused;
  }
}
