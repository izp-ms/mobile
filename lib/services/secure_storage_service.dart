import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> write({required String key, required String value}) async {
    await _secureStorage.write(key: key, value: value);
  }

  static Future<String?> read({required String key}) async {
    return await _secureStorage.read(key: key);
  }

  static Future<void> delete({required String key}) async {
    await _secureStorage.delete(key: key);
  }
}
