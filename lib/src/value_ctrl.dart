import 'package:flutter/foundation.dart';
import 'package:simple_utils/src/extensions/iterable_extension.dart';

///
class BaseChangeNotifier extends ChangeNotifier {
  bool _isDisposed = false;

  @override
  @mustCallSuper
  void notifyListeners() {
    if (_isDisposed) return;
    super.notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}

/// Value Controller
class ValueCtrl<T> extends BaseChangeNotifier implements ValueListenable<T?> {
  ///
  ValueCtrl({T? value, String? key})
      : _value = value,
        _key = key;

  final String? _key;

  T? _value;

  ///
  void clear() {
    if (_value == null) return;
    _value = null;
    notifyListeners();
  }

  /// Update value without notifying listeners
  // ignore: use_setters_to_change_properties
  void silentUpdate(T? value) {
    _value = value;
  }

  set value(T? newValue) {
    if (_value == newValue) return;
    _value = newValue;
    notifyListeners();
  }

  @override
  T? get value => _value;

  bool get hasValue => _value != null;

  bool get hasKey => _key != null;

  bool get hasEntry => hasValue && hasKey;

  String? get keyOrNull => _key;

  String get key => _key!;

  MapEntry<String, T>? get entryOrNull => hasEntry ? entry : null;

  MapEntry<String, T> get entry => MapEntry(_key!, _value as T);
}

///
extension ValueCtrlX<T> on ValueCtrl<Iterable<T>> {
  ///
  void add(T? value, {bool notify = true}) {
    if (value == null) return;
    this.value = [...?this.value, value];
    if (notify) notifyListeners();
  }

  ///
  void remove(T? value, {bool notify = true}) {
    if (value == null) return;
    this.value?.toList().removeFirstWhere((e) => e == value);
    if (notify) notifyListeners();
  }
}
