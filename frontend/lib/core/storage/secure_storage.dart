import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mirage_by_aurues/core/utils/constants.dart';

/// Wrapper around FlutterSecureStorage for auth token management.
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: AppConstants.authTokenKey, value: token);
  }

  Future<String?> getToken() async {
    return _storage.read(key: AppConstants.authTokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: AppConstants.authTokenKey);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
