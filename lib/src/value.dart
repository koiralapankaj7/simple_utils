import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      double => () {
          return double.tryParse(source) as T?;
        }(),
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

///
class Value<T> extends BaseChangeNotifier implements ValueListenable<T> {
  ///
  Value(T value) : _value = value;

  T? _prev;
  T _value;

  ///
  @override
  T get value => _value;

  ///
  T? get previous => _prev;

  @mustCallSuper
  set value(T newValue) {
    if (_value == newValue) return;
    _prev = _value;
    _value = newValue;
    notifyListeners();
  }

  ///
  // ignore: use_setters_to_change_properties
  void update(T newValue, {bool silent = false}) {
    if (silent) {
      if (_value == newValue) return;
      _prev = _value;
      _value = newValue;
      return;
    }
    value = newValue;
  }
}

/// Value Controller
class ValueCtrl<T> extends Value<T?> {
  ///
  ValueCtrl({T? value}) : super(value);

  String? _key;

  late ValueSerializer<T> _serializer = ValueSerializer<T>();

  /// Set key for the controller
  set key(String? newValue) {
    if (newValue == _key) return;
    _key = newValue;
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
    if (value == null) return;
    value = null;
    if (notifyListener) {
      notifyListeners();
    }
  }

  ///
  bool get hasValue => value != null;

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

  @override
  T? get value => _value;

  @override
  // ignore: unnecessary_overrides
  set value(T? newValue) {
    super.value = newValue;
  }
}

///
extension IterableValueX<T> on Value<Iterable<T>?> {
  ///
  void add(T? value, {bool notify = true}) {
    if (value == null) return;
    update([...?this.value, value], silent: !notify);
  }

  ///
  void addAll(Iterable<T> list, {bool notify = true}) {
    update([...?value, ...list], silent: !notify);
  }

  ///
  void remove(T? value, {bool notify = true}) {
    if (value == null) return;
    final current = [...?this.value]..removeFirstWhere((e) => e == value);
    update(current, silent: !notify);
  }

  ///
  T? removeAt(int index, {bool notify = true}) {
    final current = [...?value];
    final removed = current.removeAt(index);
    update(current, silent: !notify);
    return removed;
  }

  ///
  int indexOf(T value) => this.value?.indexOf(value) ?? -1;

  ///
  bool get isEmpty => value?.isEmpty ?? true;

  ///
  bool get isNotEmpty => value?.isNotEmpty ?? false;

  ///
  int get length => value?.length ?? 0;

  ///
  int get prevLength => _prev?.length ?? 0;

  ///
  int get delta => length == prevLength
      ? 0
      : length > prevLength
          ? 1
          : -1;
}

///
extension MapValueX<K, V> on Value<Map<K, V>?> {
  ///
  void add(K key, V value, {bool notify = true}) {
    if (value == null) return;
    update({...?this.value}..[key] = value, silent: !notify);
  }

  ///
  void addEntry(MapEntry<K, V> entry, {bool notify = true}) {
    update({...?value}..[entry.key] = entry.value, silent: !notify);
  }

  ///
  void addAll(Map<K, V> map, {bool notify = true}) {
    update({...?value}..addAll(map), silent: !notify);
  }

  ///
  void prependAll(Map<K, V> map, {bool notify = true}) {
    update({...map, ...?value}, silent: !notify);
  }

  ///
  (int, V)? remove(K key, {bool notify = true}) {
    if (value?.isEmpty ?? true) return null;
    final current = {...?value};

    (int, V)? result;
    for (final (index, entry) in current.entries.indexed) {
      if (entry.key == key) {
        result = (index, entry.value);
        current.remove(key);
        break;
      }
    }
    update(current, silent: !notify);
    return result;
  }

  ///
  int indexOf(K key) => value?.keys.indexOf(key) ?? -1;

  ///
  bool get isEmpty => value?.isEmpty ?? true;

  ///
  bool get isNotEmpty => value?.isNotEmpty ?? false;

  ///
  int get length => value?.length ?? 0;

  ///
  int get prevLength => _prev?.length ?? 0;

  ///
  int get delta => length == prevLength
      ? 0
      : length > prevLength
          ? 1
          : -1;
}

///
class SListenableBuilder extends StatefulWidget {
  /// Creates a widget that rebuilds when the given listenable changes.
  ///
  /// The [listenable] argument is required.
  const SListenableBuilder({
    required this.listenable,
    required this.builder,
    this.child,
    this.notifierPredicate,
    super.key,
  });

  /// The [Listenable] to which this widget is listening.
  ///
  /// Commonly an [Animation] or a [ChangeNotifier].
  final Listenable listenable;

  /// Called every time the [listenable] notifies about a change.
  ///
  /// The child given to the builder should typically be part of the returned
  /// widget tree.
  final TransitionBuilder builder;

  /// The child widget to pass to the [builder].
  ///
  /// {@macro flutter.widgets.transitions.ListenableBuilder.optimizations}
  final Widget? child;

  /// if return true, state will not be rebuild
  final ValueGetter<bool>? notifierPredicate;

  /// Subclasses typically do not override this method.
  @override
  State<SListenableBuilder> createState() => _SListenableState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<Listenable>('listenable', listenable));
  }
}

class _SListenableState extends State<SListenableBuilder> {
  @override
  void initState() {
    super.initState();
    widget.listenable.addListener(_handleChange);
  }

  @override
  void didUpdateWidget(SListenableBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.listenable != oldWidget.listenable) {
      oldWidget.listenable.removeListener(_handleChange);
      widget.listenable.addListener(_handleChange);
    }
  }

  @override
  void dispose() {
    widget.listenable.removeListener(_handleChange);
    super.dispose();
  }

  void _handleChange() {
    if (widget.notifierPredicate != null && !widget.notifierPredicate!()) {
      return;
    }

    setState(() {
      // The listenable's state is our build state, and it changed already.
    });
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, widget.child);
}
