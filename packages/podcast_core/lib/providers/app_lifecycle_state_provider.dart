import 'dart:io';
import 'dart:ui' as ui;

import 'package:podcast_core/helpers/platform_helpers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

export 'dart:ui' show AppLifecycleState;

part 'app_lifecycle_state_provider.g.dart';

@Riverpod(keepAlive: true)
class AppLifecycleStatePod extends _$AppLifecycleStatePod {
  @override
  ui.AppLifecycleState build() {
    return ui.AppLifecycleState.resumed;
  }

  set lifecycleState(ui.AppLifecycleState newState) {
    if (isWeb) return;

    // Only update if on mobile
    if (Platform.isAndroid || Platform.isIOS) {
      state = newState;
    }
  }

  void close() {
    state = ui.AppLifecycleState.paused;
  }
}
