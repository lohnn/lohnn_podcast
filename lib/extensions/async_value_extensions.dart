import 'package:hooks_riverpod/hooks_riverpod.dart';

extension AsyncValueRecord2Extension<T, E> on (AsyncValue<T>, AsyncValue<E>) {
  AsyncValue<(T, E)> pack() {
    return switch (($1.unwrapPrevious(), $2.unwrapPrevious())) {
      (AsyncData<T>(value: final data), AsyncData<E>(value: final data2)) =>
        AsyncData((data, data2)),
      (AsyncError<T> _, _) || (_, AsyncError<E> _) => AsyncError(
          'Error loading',
          StackTrace.current,
        ),
      _ => const AsyncLoading(),
    };
  }
}
