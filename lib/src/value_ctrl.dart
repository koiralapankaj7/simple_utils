import 'package:flutter/foundation.dart';
import 'package:simple_utils/simple_utils.dart';

///
typedef StringConverter<T> = T? Function(String? value);

///
typedef ValueConverter<T> = String? Function(T? value);

///
typedef JsonValueConverter<T> = dynamic Function(T? value);

///
class ValueSerializer<T> {
  ///
  const ValueSerializer({
    StringConverter<T>? stringConverter,
    ValueConverter<T>? valueConverter,
    JsonValueConverter<T>? jsonValueConverter,
  })  : stringConverter = stringConverter ?? defaultStringConverter,
        valueConverter = valueConverter ?? defaultValueConverter,
        jsonValueConverter =
            jsonValueConverter ?? valueConverter ?? defaultValueConverter;

  ///
  static T? defaultStringConverter<T>(String? source) {
    if (source == null) return null;
    return switch (T) {
      String => source as T?,
      int => int.tryParse(source) as T?,
      double => double.tryParse(source) as T?,
      num => num.tryParse(source) as T?,
      DateTime => DateTime.tryParse(source) as T?,
      bool => source.toBool as T?,
      _ => null,
    };
  }

  ///
  static String? defaultValueConverter<T>(T? value) => value?.toString();

  /// Convert [T] to [String]
  final StringConverter<T> stringConverter;

  /// Convert String to [T]
  final ValueConverter<T> valueConverter;

  /// Convert [T] to json value, by default [stringConverter] will be used
  final JsonValueConverter<T> jsonValueConverter;
}

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
  ValueCtrl({T? value}) : _value = value;

  T? _value;
  String? _key;

  late ValueSerializer<T> _serializer = ValueSerializer<T>();

  /// Update value without notifying listeners
  // ignore: use_setters_to_change_properties
  void silentUpdate(T? newValue) {
    if (newValue == _value) return;
    _value = newValue;
  }

  /// Set key for the controller
  set key(String? newValue) {
    if (newValue == _key) return;
    _key = newValue;
  }

  ///
  @override
  T? get value => _value;
  set value(T? newValue) {
    if (_value == newValue) return;
    _value = newValue;
    notifyListeners();
  }

  /// Set serializer
  ValueSerializer<T> get serializer => _serializer;
  set serializer(ValueSerializer<T>? newValue) {
    if (_serializer == newValue) return;
    if (newValue == null) {
      _serializer = const ValueSerializer();
      return;
    }
    _serializer = newValue;
  }

  ///
  void clear({bool notifyListener = true}) {
    if (_value == null) return;
    _value = null;
    if (notifyListener) {
      notifyListeners();
    }
  }

  ///
  bool get hasValue => _value != null;

  ///
  bool get hasKey => _key != null;

  ///
  bool get hasEntry => hasValue && hasKey;

  ///
  String? get keyOrNull => _key;

  ///
  String get key => _key!;

  ///
  MapEntry<String, dynamic>? get entryOrNull => hasEntry ? entry : null;

  ///
  MapEntry<String, dynamic> get entry =>
      MapEntry(_key!, _serializer.jsonValueConverter(value));
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
