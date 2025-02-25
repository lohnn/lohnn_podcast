import 'package:hooks_riverpod/hooks_riverpod.dart';

extension AsyncValueRecord2Extension<T, E> on (AsyncValue<T>, AsyncValue<E>) {
  AsyncValue<(T, E)> pack() {
    return switch (($1, $2)) {
      (AsyncValue<T>(value: final data?), AsyncValue<E>(value: final data2?)) =>
        AsyncData((data, data2)),
      (AsyncError<T>(:final error, :final stackTrace), _) ||
      (
        _,
        AsyncError<E>(:final error, :final stackTrace),
      ) => AsyncError(error, stackTrace),
      _ => const AsyncLoading(),
    };
  }
}

extension AsyncValueRecord3Extension<T, E, S>
    on (AsyncValue<T>, AsyncValue<E>, AsyncValue<S>) {
  AsyncValue<(T, E, S)> pack() {
    return switch (($1, $2, $3)) {
      (
        AsyncValue<T>(value: final data?),
        AsyncValue<E>(value: final data2?),
        AsyncValue<S>(value: final data3?),
      ) =>
        AsyncData((data, data2, data3)),
      (AsyncError<T>(:final error, :final stackTrace), _, _) ||
      (_, AsyncError<E>(:final error, :final stackTrace), _) ||
      (
        _,
        _,
        AsyncError<S>(:final error, :final stackTrace),
      ) => AsyncError(error, stackTrace),
      _ => const AsyncLoading(),
    };
  }
}
