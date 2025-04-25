// ignore: deprecated_member_use
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

extension RefExtensions on Ref<Object> {
  void listenListenable<T>(
    Future<Listenable> futureListenable,
    void Function() onChanged,
  ) {
    futureListenable.then((listenable) {
      listenable.addListener(onChanged);
      onDispose(() => listenable.removeListener(onChanged));
    });
  }
}
