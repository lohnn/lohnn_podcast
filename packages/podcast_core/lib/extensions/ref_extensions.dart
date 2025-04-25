// ignore: deprecated_member_use
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

extension RefExtensions on Ref<Object> {
  void listenChangeNotifier<T>(
    ChangeNotifier watchEpisodesFor,
    void Function() onChanged,
  ) {
    watchEpisodesFor.addListener(onChanged);
    onDispose(() => watchEpisodesFor.removeListener(onChanged));
  }
}
