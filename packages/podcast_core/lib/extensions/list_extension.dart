extension IterableExtension<T> on Iterable<T> {
  List<T> reorder(int oldIndex, int newIndex) {
    return toList()._reorder(oldIndex, newIndex);
  }

  List<S> expandToList<S>(Iterable<S> Function(T) toElements) {
    return expand(toElements).toList();
  }
}

extension ListExtension<T> on List<T> {
  List<T> _reorder(int oldIndex, int newIndex) {
    final adjustedIndex = (oldIndex < newIndex) ? newIndex - 1 : newIndex;
    final item = removeAt(oldIndex);
    insert(adjustedIndex, item);
    return this;
  }
}
