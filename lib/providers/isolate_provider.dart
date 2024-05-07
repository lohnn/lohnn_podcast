import 'package:flutter/foundation.dart';
import 'package:integral_isolates/integral_isolates.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'isolate_provider.g.dart';

@Riverpod(keepAlive: true)
StatefulIsolate isolate(IsolateRef ref, Key key) {
  final isolate = StatefulIsolate();
  ref.onDispose(isolate.dispose);
  return isolate;
}
