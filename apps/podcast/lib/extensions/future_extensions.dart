extension FutureExtensions<T> on Future<List<T>> {
  Future<T> get first => then((e) => e.first);

  Future<T> get single => then((e) => e.single);

  Future<T?> get firstOrNull => then((e) => e.firstOrNull);
}
