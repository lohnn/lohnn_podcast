import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'socket_provider.g.dart';

typedef SocketActive = bool;

@Riverpod(keepAlive: true)
class SocketPod extends _$SocketPod {
  @override
  SocketActive build() {
    return true;
  }

  void open() => state = true;

  void close() => state = false;
}
