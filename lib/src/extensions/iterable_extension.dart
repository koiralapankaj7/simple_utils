import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Axis, SizedBox, Widget;

/// Useful extension functions for [Iterable]
extension IterableX<T> on Iterable<T?> {
  /// Removes all the null values
  /// and converts `Iterable<T?>` into `Iterable<T>`
  Iterable<T> get withNullifier => whereType();

  /// Insert any item<T> inBetween the list items
  // List<T> insertBetween(T item) => expand((e) sync* {
  //       yield item;
  //       yield e!;
  //     }).skip(1).toList(growable: false);

  int indexOf(T value) {
    var index = 0;
    for (final element in this) {
      if (value == element) {
        return index;
      }
      index++;
    }
    return -1;
  }
}

///
extension WidgetX on Iterable<Widget> {
  ///
  List<Widget> paddedInBetween({
    double space = 12.0,
    Axis axis = Axis.horizontal,
  }) {
    final c = List.of(this);
    final widget = SizedBox(
      width: axis == Axis.horizontal ? space : null,
      height: axis == Axis.vertical ? space : null,
    );
    for (var i = c.length; i-- > 0;) {
      if (i > 0) {
        c.insert(i, widget);
      }
    }
    return c;
  }

  ///
  List<Widget> insertBetween(Widget Function(int index) builder) {
    final c = <Widget>[...this];
    for (var i = c.length; i-- > 0;) {
      if (i < c.length - 1) {
        c.insert(i + 1, builder(i));
      }
    }
    return c;
  }

  ///
  List<Widget> paddedX({double space = 12.0}) {
    final c = List.of(this);
    for (var i = c.length; i-- > 0;) {
      if (i > 0) {
        c.insert(i, SizedBox(width: space));
      }
    }
    return c;
  }

  ///
  List<Widget> paddedY({double space = 12.0}) {
    final c = List.of(this);
    for (var i = c.length; i-- > 0;) {
      if (i > 0) {
        c.insert(i, SizedBox(height: space));
      }
    }
    return c;
  }
}

///
extension ListX<T> on List<T> {
  /// Remove the first occurrence of the item returned from the [test] callback.
  ///
  /// Returns the removed value.
  T? removeFirstWhere(bool Function(T e) test) {
    for (var i = 0; i < length; i++) {
      if (test(this[i])) {
        return removeAt(i);
      }
    }
    return null;
  }

  ///
  int replaceFirst(T? Function(T e) test) {
    for (var i = 0; i < length; i++) {
      final res = test(this[i]);
      if (res != null) {
        this[i] = res;
        return i;
      }
    }
    return -1;
  }

  ///
  MapEntry<int, T>? firstEntryWhereOrNull(bool Function(T e) test) {
    var index = 0;
    for (final element in this) {
      if (test(element)) return MapEntry(index, element);
      index++;
    }
    return null;
  }

  ///
  void replaceWhere(List<T> replacements, bool Function(T) test) {
    if (replacements.isEmpty) return;
    final iterator = replacements.iterator;
    for (var i = 0; i < length; i++) {
      final item = this[i];
      if (test(item)) {
        if (iterator.moveNext()) {
          this[i] = iterator.current;
        } else {
          break; // No more replacements, stop iterating
        }
      }
    }
  }
}

///
extension MapX<K, V> on Map<K, V> {
  ///
  MapEntry<K, V> entryAt(int index) {
    if (index < 0 || index >= length) {
      throw IndexError.withLength(index, length);
    }
    for (final (i, entry) in entries.indexed) {
      if (i == index) return entry;
    }
    throw UnsupportedError('');
  }
}

/// Useful extension functions for [Map]
extension MapNullableX<K, V> on Map<K?, V?> {
  /// Returns a new map with null keys or values removed
  Map<K, V> get nullProtected {
    final nullProtected = {...this}
      ..removeWhere((key, value) => key == null || value == null);
    return nullProtected.cast();
  }
}

///
extension ListenableIterableX on Iterable<ValueListenable<dynamic>> {
  ///
  bool get hasValue =>
      isEmpty || firstWhereOrNull((e) => e.value == null) == null;
}
