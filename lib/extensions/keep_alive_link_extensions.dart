import 'package:hooks_riverpod/hooks_riverpod.dart';

extension KeepAliveLinkExtension on KeepAliveLink {
  /// Allows for easy handling of automatically closing a [KeepAliveLink] if a
  /// [Future] throws.
  Future<T> tryRunAsync<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } catch (_) {
      close();
      rethrow;
    }
  }
}
