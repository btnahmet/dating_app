import 'dart:io';
import 'package:dio/dio.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/services/logger_service.dart';

abstract class AuthRemoteDataSource {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> register(String name, String email, String password);
  Future<void> uploadPhoto(String photoPath);
  Future<UserEntity> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final response = await dio.post('/user/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        return UserEntity(
          id: data['id'] ?? '',
          name: data['name'] ?? '',
          email: email,
          token: data['token'],
        );
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      throw Exception('Login error: $e');
    }
  }

  @override
  Future<UserEntity> register(String name, String email, String password) async {
    try {
      final response = await dio.post('/user/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        return UserEntity(
          id: data['id'] ?? '',
          name: name,
          email: email,
          token: data['token'],
        );
      } else {
        throw Exception('Registration failed');
      }
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  @override
  Future<void> uploadPhoto(String photoPath) async {
    try {
      // Dosya boyutunu kontrol et
      final file = File(photoPath);
      if (!await file.exists()) {
        throw Exception('Dosya bulunamadı: $photoPath');
      }
      
      // Dosya boyutunu kontrol et (5MB limit)
      final fileSize = await file.length();
      if (fileSize > 5 * 1024 * 1024) {
        throw Exception('Dosya boyutu çok büyük (max 5MB)');
      }
      
      // MultipartFile oluştur
      final multipartFile = await MultipartFile.fromFile(
        photoPath,
        filename: 'profile_photo.jpg',
        contentType: DioMediaType('image', 'jpeg'),
      );
      
      // FormData oluştur - farklı field adlarını dene
      final formData = FormData.fromMap({
        'image': multipartFile,
      });
      
      // Content-Type header'ını manuel olarak ayarla
      final response = await dio.post(
        '/user/upload_photo',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Fotoğraf yüklendikten sonra profil bilgilerini güncelle
        final photoUrl = response.data['photoUrl'] ?? response.data['data']?['photoUrl'];
        if (photoUrl != null) {
          // Profil güncelleme işlemini atla, sadece fotoğraf yükleme başarılı
          LoggerService.log('Fotoğraf yükleme başarılı, profil güncelleme atlanıyor');
        }
      } else {
        throw Exception('Photo upload failed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Photo upload error: $e');
    }
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    try {
      final response = await dio.get('/user/profile');

      if (response.statusCode == 200) {
        final data = response.data['data'] as Map<String, dynamic>;
        return UserEntity(
          id: data['id'] ?? '',
          name: data['name'] ?? '',
          email: data['email'] ?? '',
          photoUrl: data['photoUrl'],
        );
      } else {
        throw Exception('Failed to get current user');
      }
    } catch (e) {
      throw Exception('Get current user error: $e');
    }
  }
} 