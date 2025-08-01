import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final response = await remoteDataSource.login(email, password);
      await localDataSource.saveToken(response.token ?? '');
      return response;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<UserEntity> register(String name, String email, String password) async {
    try {
      final response = await remoteDataSource.register(name, email, password);
      await localDataSource.saveToken(response.token ?? '');
      return response;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<void> uploadPhoto(String photoPath) async {
    try {
      await remoteDataSource.uploadPhoto(photoPath);
    } catch (e) {
      throw Exception('Photo upload failed: $e');
    }
  }

  @override
  Future<void> logout() async {
    await localDataSource.clearToken();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final token = await localDataSource.getToken();
    if (token != null) {
      return await remoteDataSource.getCurrentUser();
    }
    return null;
  }
} 