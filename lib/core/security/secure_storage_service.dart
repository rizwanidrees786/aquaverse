import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final FlutterSecureStorage _storage;
  final Map<String, String> _memoryFallback = <String, String>{};

  Future<void> writeSecret(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (_) {
      _memoryFallback[key] = value;
    }
  }

  Future<String?> readSecret(String key) async {
    try {
      final value = await _storage.read(key: key);
      return value ?? _memoryFallback[key];
    } catch (_) {
      return _memoryFallback[key];
    }
  }

  Future<void> deleteSecret(String key) async {
    _memoryFallback.remove(key);
    try {
      await _storage.delete(key: key);
    } catch (_) {
      // Ignore if platform storage unavailable in test environment.
    }
  }
}
