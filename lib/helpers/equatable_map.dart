import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

extension EquatableMapExtension<K, V> on Map<K, V> {
  EquatableMap<K, V> get equatable => EquatableMap(this);
}

/// A helper class to wrap an iterable with support for [==] and [hashCode].
///
/// Currently this only supports ordered checks, meaning that if a List or
/// Set is checking against an object of the same type, but different order, it
/// will not equal.
@immutable
class EquatableMap<K, V> implements Map<K, V> {
  final Map<K, V> _data;

  const EquatableMap(this._data);

  const EquatableMap.empty() : _data = const {};

  static const _equality = MapEquality();

  @override
  int get hashCode => _equality.hash(_data);

  @override
  bool operator ==(Object other) {
    return other is EquatableMap<K, V> &&
        _equality.equals(
          _data,
          other._data,
        );
  }
  
  @override
  String toString() {
    return 'EquatableMap<$K, $V>{$_data}';
  }

  @override
  int get length => _data.length;

  @override
  void clear() => _data.clear();

  @override
  bool get isEmpty => _data.isEmpty;

  @override
  bool get isNotEmpty => _data.isNotEmpty;

  @override
  void addEntries(Iterable<MapEntry<K, V>> newEntries) =>
      _data.addEntries(newEntries);

  @override
  bool containsKey(Object? key) => _data.containsKey(key);

  @override
  bool containsValue(Object? value) => _data.containsValue(value);

  @override
  Iterable<MapEntry<K, V>> get entries => _data.entries;

  @override
  Iterable<K> get keys => _data.keys;

  @override
  V putIfAbsent(K key, V Function() ifAbsent) =>
      _data.putIfAbsent(key, ifAbsent);

  @override
  V update(K key, V Function(V value) update, {V Function()? ifAbsent}) =>
      _data.update(key, update, ifAbsent: ifAbsent);

  @override
  void updateAll(V Function(K key, V value) update) => _data.updateAll(update);

  @override
  Iterable<V> get values => _data.values;

  @override
  V? operator [](Object? key) => _data[key];

  @override
  void operator []=(K key, V value) => _data[key] = value;

  @override
  void addAll(Map<K, V> other) => _data.addAll(other);

  @override
  Map<RK, RV> cast<RK, RV>() => _data.cast<RK, RV>();

  @override
  void forEach(void Function(K key, V value) action) => _data.forEach(action);

  @override
  Map<K2, V2> map<K2, V2>(MapEntry<K2, V2> Function(K key, V value) convert) =>
      _data.map(convert);

  @override
  V? remove(Object? key) => _data.remove(key);

  @override
  void removeWhere(bool Function(K key, V value) test) =>
      _data.removeWhere(test);
}
