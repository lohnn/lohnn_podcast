extension ObjectExtension<T> on T {
  @pragma('vm:prefer-inline')
  E let<E>(E Function(T data) action) => action(this);
}

extension BoolExtension on bool {
  /// If bool is true, the function is called and returns the value.
  /// Otherwise this returns null.
  /// Equivalent to (equalityCheck) ? toElement() : null
  @pragma('vm:prefer-inline')
  E? thenOrNull<E>(E? Function() toElement) {
    if (this == true) return toElement();
    return null;
  }
}
