import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
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

/// Text Field Value Controller
abstract class TFCtrl<T> extends ValueCtrl<T> {
  ///
  TFCtrl({super.key, super.value})
      : editingController = TextEditingController(text: value?.toString()) {
    editingController.addListener(_listener);
  }

  ///
  final TextEditingController editingController;

  ///
  void _listener() {
    _value = convertedValue;
    notifyListeners();
  }

  T? get convertedValue;

  /// Convert [T] to [String]
  String? stringValue(T? value) => value?.toString();

  @override
  void silentUpdate(T? value) {
    super.silentUpdate(value);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      editingController.text = stringValue(value) ?? '';
    });
  }

  @override
  set value(T? newValue) {
    super.value = newValue;
    editingController.text = stringValue(newValue) ?? '';
  }

  @override
  void clear() {
    super.clear();
    editingController.clear();
  }

  @override
  void dispose() {
    editingController
      ..removeListener(_listener)
      ..dispose();
    super.dispose();
  }
}

/// Text Field Integer Value Controller
class IntTFCtrl extends TFCtrl<int> {
  IntTFCtrl({super.key, super.value}) : super();

  @override
  int? get convertedValue => int.tryParse(editingController.text);
}

/// Text Field Double Value Controller
class DoubleTFCtrl extends TFCtrl<double> {
  DoubleTFCtrl({super.key, super.value});

  @override
  double? get convertedValue => double.tryParse(editingController.text);
}

/// Text Field String Value Controller
class StringTFCtrl extends TFCtrl<String> {
  StringTFCtrl({super.key, super.value}) : super();

  @override
  String? get convertedValue => editingController.text;

  @override
  bool get hasValue => value?.isNotEmpty ?? false;
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
