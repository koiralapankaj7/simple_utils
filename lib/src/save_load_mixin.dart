import 'package:flutter/foundation.dart';

import 'hive_file.dart';
import 'throttler.dart';

///
mixin ThrottledSaveLoadMixin {
  late final _file = HiveFile(fileName, encrypted: encrypted);
  final _throttle = Throttler(const Duration(seconds: 2));

  ///
  bool get pauseScheduleSave => false;

  ///
  bool get encrypted => false;

  ///
  Future<void> load() async {
    final results = await _file.load();
    try {
      copyFromJson(results);
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  ///
  Future<void> save() async {
    debugPrint('Saving...');
    try {
      await _file.save(toJson());
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  ///
  Future<void> scheduleSave() async {
    if (pauseScheduleSave) return;
    return _throttle.call(save);
  }

  /// Serialization
  String get fileName;

  ///
  Map<String, dynamic> toJson();

  ///
  void copyFromJson(Map<String, dynamic> value);
}
