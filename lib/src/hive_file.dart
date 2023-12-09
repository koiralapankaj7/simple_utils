import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

///
class HiveFile {
  ///
  const HiveFile(this.name, {this.encrypted = false});

  ///
  final String name;

  ///
  final bool encrypted;

  Future<Uint8List> get _key async {
    const secureStorage = FlutterSecureStorage();
    final key = await secureStorage.read(key: 'key');
    if (key == null) {
      final newKey = Hive.generateSecureKey();
      await secureStorage.write(
        key: 'key',
        value: base64UrlEncode(newKey),
      );
      return Uint8List.fromList(newKey);
    }
    return base64Url.decode(key);
  }

  ///
  Future<Map<String, dynamic>> load() async {
    final cipher = encrypted ? HiveAesCipher(await _key) : null;
    final box = await Hive.openLazyBox<Map<dynamic, dynamic>>(
      name,
      encryptionCipher: cipher,
    );
    final json = await box.get(name);
    return Map<String, dynamic>.from(json ?? <String, dynamic>{});
  }

  ///
  Future<void> save(Map<String, dynamic> data) async {
    final cipher = encrypted ? HiveAesCipher(await _key) : null;
    final box = await Hive.openLazyBox<Map<dynamic, dynamic>>(
      name,
      encryptionCipher: cipher,
    );
    await box.put(name, data);
  }
}
