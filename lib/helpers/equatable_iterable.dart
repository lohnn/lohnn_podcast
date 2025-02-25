import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

extension EquatableIterableExtension<E> on Iterable<E> {
  EquatableIterable<E> get equatable => EquatableIterable(this);
}

/// A helper class to wrap an iterable with support for [==] and [hashCode].
///
/// Currently this only supports ordered checks, meaning that if a List or
/// Set is checking against an object of the same type, but different order, it
/// will not equal.
@immutable
class EquatableIterable<E> extends Iterable<E> {
  final Iterable<E> _data;

  const EquatableIterable(this._data);

  const EquatableIterable.empty() : _data = const {};

  @override
  Iterator<E> get iterator => _data.iterator;

  static const _equality = IterableEquality();

  @override
  int get hashCode => _equality.hash(_data);

  @override
  bool operator ==(Object other) {
    return other is EquatableIterable<E> && _equality.equals(_data, other);
  }
}
