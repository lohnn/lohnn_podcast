import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';

extension EquatableListExtension<E> on List<E> {
  EquatableList<E> get equatable => EquatableList(this);
}

/// A helper class to wrap an iterable with support for [==] and [hashCode].
///
/// Currently this only supports ordered checks, meaning that if a List or
/// Set is checking against an object of the same type, but different order, it
/// will not equal.
@immutable
class EquatableList<E> implements List<E> {
  final List<E> _data;

  const EquatableList(this._data);

  const EquatableList.empty() : _data = const [];

  @override
  Iterator<E> get iterator => _data.iterator;

  static const _equality = ListEquality();

  @override
  int get hashCode => _equality.hash(_data);

  @override
  bool operator ==(Object other) {
    return other is EquatableList<E> && _equality.equals(_data, other._data);
  }

  @override
  E operator [](int index) => _data[index];

  @override
  E get first => _data.first;

  @override
  E get last => _data.last;

  @override
  int get length => _data.length;

  @override
  List<E> operator +(List<E> other) {
    return _data + other;
  }

  @override
  void operator []=(int index, E value) {
    _data[index] = value;
  }

  @override
  void add(E value) {
    _data.add(value);
  }

  @override
  void addAll(Iterable<E> iterable) {
    _data.addAll(iterable);
  }

  @override
  bool any(bool Function(E element) test) {
    return _data.any(test);
  }

  @override
  Map<int, E> asMap() {
    return _data.asMap();
  }

  @override
  List<R> cast<R>() {
    return _data.cast<R>();
  }

  @override
  void clear() {
    _data.clear();
  }

  @override
  bool contains(Object? element) {
    return _data.contains(element);
  }

  @override
  E elementAt(int index) {
    return _data.elementAt(index);
  }

  @override
  bool every(bool Function(E element) test) {
    return _data.every(test);
  }

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E element) toElements) {
    return _data.expand(toElements);
  }

  @override
  void fillRange(int start, int end, [E? fillValue]) {
    _data.fillRange(start, end, fillValue);
  }

  @override
  E firstWhere(bool Function(E element) test, {E Function()? orElse}) {
    return _data.firstWhere(test, orElse: orElse);
  }

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) {
    return _data.fold(initialValue, combine);
  }

  @override
  Iterable<E> followedBy(Iterable<E> other) {
    return _data.followedBy(other);
  }

  @override
  void forEach(void Function(E element) action) {
    _data.forEach(action);
  }

  @override
  Iterable<E> getRange(int start, int end) {
    return _data.getRange(start, end);
  }

  @override
  int indexOf(E element, [int start = 0]) {
    return _data.indexOf(element, start);
  }

  @override
  int indexWhere(bool Function(E element) test, [int start = 0]) {
    return _data.indexWhere(test, start);
  }

  @override
  void insert(int index, E element) {
    _data.insert(index, element);
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    _data.insertAll(index, iterable);
  }

  @override
  bool get isEmpty => _data.isEmpty;

  @override
  bool get isNotEmpty => _data.isNotEmpty;

  @override
  String join([String separator = '']) {
    return _data.join(separator);
  }

  @override
  int lastIndexOf(E element, [int? start]) {
    return _data.lastIndexOf(element, start);
  }

  @override
  int lastIndexWhere(bool Function(E element) test, [int? start]) {
    return _data.lastIndexWhere(test, start);
  }

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) {
    return _data.lastWhere(test, orElse: orElse);
  }

  @override
  Iterable<T> map<T>(T Function(E e) toElement) {
    return _data.map(toElement);
  }

  @override
  E reduce(E Function(E value, E element) combine) {
    return _data.reduce(combine);
  }

  @override
  bool remove(Object? value) {
    return _data.remove(value);
  }

  @override
  E removeAt(int index) {
    return _data.removeAt(index);
  }

  @override
  E removeLast() {
    return _data.removeLast();
  }

  @override
  void removeRange(int start, int end) {
    _data.removeRange(start, end);
  }

  @override
  void removeWhere(bool Function(E element) test) {
    _data.removeWhere(test);
  }

  @override
  void replaceRange(int start, int end, Iterable<E> replacements) {
    _data.replaceRange(start, end, replacements);
  }

  @override
  void retainWhere(bool Function(E element) test) {
    _data.retainWhere(test);
  }

  @override
  Iterable<E> get reversed => _data.reversed;

  @override
  void setAll(int index, Iterable<E> iterable) {
    _data.setAll(index, iterable);
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    _data.setRange(start, end, iterable, skipCount);
  }

  @override
  void shuffle([Random? random]) {
    _data.shuffle(random);
  }

  @override
  E get single => _data.single;

  @override
  E singleWhere(bool Function(E element) test, {E Function()? orElse}) {
    return _data.singleWhere(test, orElse: orElse);
  }

  @override
  Iterable<E> skip(int count) {
    return _data.skip(count);
  }

  @override
  Iterable<E> skipWhile(bool Function(E value) test) {
    return _data.skipWhile(test);
  }

  @override
  void sort([int Function(E a, E b)? compare]) {
    _data.sort(compare);
  }

  @override
  List<E> sublist(int start, [int? end]) {
    return _data.sublist(start, end);
  }

  @override
  Iterable<E> take(int count) {
    return _data.take(count);
  }

  @override
  Iterable<E> takeWhile(bool Function(E value) test) {
    return _data.takeWhile(test);
  }

  @override
  List<E> toList({bool growable = true}) {
    return _data.toList(growable: growable);
  }

  @override
  Set<E> toSet() {
    return _data.toSet();
  }

  @override
  Iterable<E> where(bool Function(E element) test) {
    return _data.where(test);
  }

  @override
  Iterable<T> whereType<T>() {
    return _data.whereType<T>();
  }

  @override
  set first(E value) {
    _data.first = value;
  }

  @override
  set last(E value) {
    _data.last = value;
  }

  @override
  set length(int newLength) {
    _data.length = newLength;
  }
}
