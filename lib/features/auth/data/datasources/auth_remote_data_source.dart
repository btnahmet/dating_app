import 'package:dio/dio.dart';
import '../../domain/entities/user_entity.dart';

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
      final file = await MultipartFile.fromFile(photoPath);
      final formData = FormData.fromMap({
        'photo': file,
      });

      final response = await dio.post('/user/upload_photo', data: formData);

      if (response.statusCode != 200) {
        throw Exception('Photo upload failed');
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