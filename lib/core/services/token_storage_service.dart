import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'logger_service.dart';

class TokenStorageService {
  static const String _tokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  
  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  // Token işlemleri
  Future<void> saveToken(String token) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
      LoggerService.log('Token başarıyla kaydedildi');
    } catch (e) {
      LoggerService.error('Token kaydedilirken hata: $e');
      rethrow;
    }
  }

  Future<String?> getToken() async {
    try {
      final token = await _storage.read(key: _tokenKey);
      LoggerService.log('Token alındı: ${token != null ? 'Mevcut' : 'Yok'}');
      return token;
    } catch (e) {
      LoggerService.error('Token alınırken hata: $e');
      return null;
    }
  }

  Future<void> clearToken() async {
    try {
      await _storage.delete(key: _tokenKey);
      LoggerService.log('Token temizlendi');
    } catch (e) {
      LoggerService.error('Token temizlenirken hata: $e');
      rethrow;
    }
  }

  // Refresh token işlemleri
  Future<void> saveRefreshToken(String refreshToken) async {
    try {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
      LoggerService.log('Refresh token kaydedildi');
    } catch (e) {
      LoggerService.error('Refresh token kaydedilirken hata: $e');
      rethrow;
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      LoggerService.error('Refresh token alınırken hata: $e');
      return null;
    }
  }

  // Kullanıcı bilgileri
  Future<void> saveUserInfo(String userId, String email) async {
    try {
      await _storage.write(key: _userIdKey, value: userId);
      await _storage.write(key: _userEmailKey, value: email);
      LoggerService.log('Kullanıcı bilgileri kaydedildi');
    } catch (e) {
      LoggerService.error('Kullanıcı bilgileri kaydedilirken hata: $e');
      rethrow;
    }
  }

  Future<Map<String, String?>> getUserInfo() async {
    try {
      final userId = await _storage.read(key: _userIdKey);
      final email = await _storage.read(key: _userEmailKey);
      return {'userId': userId, 'email': email};
    } catch (e) {
      LoggerService.error('Kullanıcı bilgileri alınırken hata: $e');
      return {'userId': null, 'email': null};
    }
  }

  // Tüm verileri temizle
  Future<void> clearAllData() async {
    try {
      await _storage.deleteAll();
      LoggerService.log('Tüm veriler temizlendi');
    } catch (e) {
      LoggerService.error('Veriler temizlenirken hata: $e');
      rethrow;
    }
  }

  // Token geçerliliğini kontrol et
  Future<bool> hasValidToken() async {
    try {
      final token = await getToken();
      if (token == null) return false;
      
      // Token'ın geçerliliğini kontrol et (JWT decode)
      // Bu basit bir kontrol, gerçek uygulamada JWT decode yapılmalı
      return token.isNotEmpty;
    } catch (e) {
      LoggerService.error('Token geçerliliği kontrol edilirken hata: $e');
      return false;
    }
  }
}
