import 'dart:async';

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer._({required this.delay});

  /// Used for inexpensive operations
  factory Debouncer.short() =>
      Debouncer._(delay: const Duration(milliseconds: 400));

  /// Used for expensive operations
  factory Debouncer.long() =>
      Debouncer._(delay: const Duration(milliseconds: 2000));

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void cancel() => _timer?.cancel();
}
