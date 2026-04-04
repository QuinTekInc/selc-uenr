

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  static const _authTokenKey = 'auth_token';

  static Future<void> saveTokens(String access, String refresh) async {
    await _storage.write(key: _accessTokenKey, value: access);
    await _storage.write(key: _refreshTokenKey, value: refresh);
  }

  static Future<void> saveAuthToken(String authToken) async {
    await _storage.write(key: _authTokenKey, value: authToken);
  }

  static Future<String?> getAccessToken() async => await _storage.read(key: _accessTokenKey);

  static Future<String?> getRefreshToken() async => await _storage.read(key: _refreshTokenKey);

  static Future<String?> getAuthToken() async => await _storage.read(key: _authTokenKey);

  static Future<void> clearData() async => await _storage.deleteAll();
}