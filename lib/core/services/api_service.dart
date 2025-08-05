import 'dart:io';
import 'package:dio/dio.dart';
import 'token_storage_service.dart';
import 'logger_service.dart';

class ApiService {
  static const String _baseUrl = "https://caseapi.servicelabs.tech";
  static const Duration _timeout = Duration(seconds: 30);
  
  late final Dio _dio;
  final TokenStorageService _tokenStorage = TokenStorageService();

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: _timeout,
      receiveTimeout: _timeout,
      sendTimeout: _timeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        LoggerService.log('API Request: ${options.method} ${options.path}');
        
        final token = await _tokenStorage.getToken();
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
          LoggerService.log('Token eklendi');
        }
        
        return handler.next(options);
      },
      onResponse: (response, handler) {
        LoggerService.log('API Response: ${response.statusCode} ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (error, handler) async {
        LoggerService.error('API Error: ${error.response?.statusCode} ${error.requestOptions.path}');
        
        // 401 hatası durumunda token'ı temizle
        if (error.response?.statusCode == 401) {
          await _tokenStorage.clearToken();
          LoggerService.log('401 hatası, token temizlendi');
        }
        
        return handler.next(error);
      },
    ));
  }

  Dio get dio => _dio;

  // Login API endpoint
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      LoggerService.log('Login API çağrısı başlatılıyor...');
      
      final response = await _dio.post('/user/login', data: {
        'email': email,
        'password': password,
      });
      
      LoggerService.log('Login API yanıtı: ${response.statusCode}');
      LoggerService.log('Login API verisi: ${response.data}');
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Login başarısız');
      }
    } on DioException catch (e) {
      LoggerService.error('Login DioException', e);
      LoggerService.log('Status Code: ${e.response?.statusCode}');
      LoggerService.log('Response Data: ${e.response?.data}');
      throw Exception('Login hatası: ${e.message}');
    } catch (e) {
      LoggerService.error('Login genel hata', e);
      throw Exception('Login hatası: $e');
    }
  }

  // Register API endpoint
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      LoggerService.log('Register API çağrısı başlatılıyor...');
      
      final response = await _dio.post('/user/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      
      LoggerService.log('Register API yanıtı: ${response.statusCode}');
      LoggerService.log('Register API verisi: ${response.data}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Register başarılı, kullanıcı bilgilerini token'a ekle
        final data = response.data['data'] ?? response.data;
        if (data['token'] != null) {
          // Token'ı kaydet
          await TokenStorageService().saveToken(data['token']);
          LoggerService.log('Register sonrası token kaydedildi');
        }
        return response.data;
      } else {
        throw Exception('Kayıt başarısız');
      }
    } on DioException catch (e) {
      LoggerService.error('Register DioException', e);
      LoggerService.log('Status Code: ${e.response?.statusCode}');
      LoggerService.log('Response Data: ${e.response?.data}');
      throw Exception('Kayıt hatası: ${e.message}');
    } catch (e) {
      LoggerService.error('Register genel hata', e);
      throw Exception('Kayıt hatası: $e');
    }
  }

  // Logout API endpoint
  Future<void> logout() async {
    try {
      LoggerService.log('Logout API çağrısı başlatılıyor...');
      
      final response = await _dio.post('/user/logout');
      
      LoggerService.log('Logout API yanıtı: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        // Token'ı temizle
        await TokenStorageService().clearToken();
        LoggerService.log('Logout başarılı, token temizlendi');
      } else {
        throw Exception('Logout başarısız');
      }
    } on DioException catch (e) {
      LoggerService.error('Logout DioException', e);
      // API hatası olsa bile token'ı temizle
      await TokenStorageService().clearToken();
      LoggerService.log('Logout API hatası, token temizlendi');
    } catch (e) {
      LoggerService.error('Logout genel hata', e);
      // Genel hata olsa bile token'ı temizle
      await TokenStorageService().clearToken();
      LoggerService.log('Logout genel hata, token temizlendi');
    }
  }

    // Upload photo API endpoint
  Future<Map<String, dynamic>> uploadPhoto(File photoFile) async {
    try {
      LoggerService.log('Upload photo API çağrısı başlatılıyor...');
      
      // Dosya boyutunu kontrol et
      if (!await photoFile.exists()) {
        throw Exception('Dosya bulunamadı: ${photoFile.path}');
      }
      
      final fileSize = await photoFile.length();
      if (fileSize > 5 * 1024 * 1024) {
        throw Exception('Dosya boyutu çok büyük (max 5MB)');
      }
      
      // API dokümantasyonuna göre field adı 'file' olmalı
      LoggerService.log('API dokümantasyonuna göre field adı: file');
      
      final multipartFile = await MultipartFile.fromFile(
        photoFile.path,
        filename: 'profile_photo.jpg',
        contentType: DioMediaType('image', 'jpeg'),
      );
      
      final formData = FormData.fromMap({
        'file': multipartFile, // API dokümantasyonuna göre 'file'
      });
      
      final response = await _dio.post(
        '/user/upload_photo',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );
      
      LoggerService.log('Upload photo API yanıtı: ${response.statusCode}');
      LoggerService.log('Upload photo API verisi: ${response.data}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Fotoğraf yüklendikten sonra profil bilgilerini güncelle
        final photoUrl = response.data['photoUrl'] ?? response.data['data']?['photoUrl'];
        if (photoUrl != null) {
          LoggerService.log('Fotoğraf URL\'i alındı: $photoUrl');
          // API'de profil güncelleme endpoint'i yok, sadece fotoğraf yükleme başarılı
          LoggerService.log('Fotoğraf yükleme başarılı, profil güncelleme endpoint\'i yok');
        }
        return response.data;
      } else {
        throw Exception('Fotoğraf yükleme başarısız: ${response.statusCode}');
      }
    } on DioException catch (e) {
      LoggerService.error('Upload photo DioException', e);
      LoggerService.log('Status Code: ${e.response?.statusCode}');
      LoggerService.log('Response Data: ${e.response?.data}');
      throw Exception('Fotoğraf yükleme hatası: ${e.message}');
    } catch (e) {
      LoggerService.error('Upload photo genel hata', e);
      throw Exception('Fotoğraf yükleme hatası: $e');
    }
  }

  // Update user profile API endpoint - API'de böyle bir endpoint yok
  // Sadece fotoğraf yükleme var, profil güncelleme yok
  Future<Map<String, dynamic>> updateUserProfile(String photoUrl) async {
    LoggerService.log('API\'de profil güncelleme endpoint\'i yok, sadece fotoğraf yükleme var');
    LoggerService.log('Fotoğraf URL\'i: $photoUrl');
    // API'de profil güncelleme endpoint'i olmadığı için başarılı sayıyoruz
    return {'photoUrl': photoUrl};
  }

  // Get current user API endpoint
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      LoggerService.log('Get current user API çağrısı başlatılıyor...');
      
      final response = await _dio.get('/user/profile');
      
      LoggerService.log('Get current user API yanıtı: ${response.statusCode}');
      LoggerService.log('Get current user API verisi: ${response.data}');
      
      if (response.statusCode == 200) {
        // API response'da data wrapper'ı var, onu çıkar
        final responseData = response.data;
        final userData = responseData['data'] ?? responseData;
        
        LoggerService.log('Kullanıcı verisi: $userData');
        
        // Eğer userData null veya boş ise, null döndür
        if (userData == null || userData.isEmpty) {
          LoggerService.log('Kullanıcı verisi boş, null döndürülüyor');
          return null;
        }
        
        return userData;
      } else {
        LoggerService.log('Get current user başarısız, null döndürülüyor');
        return null;
      }
    } on DioException catch (e) {
      LoggerService.error('Get current user DioException', e);
      LoggerService.log('Status Code: ${e.response?.statusCode}');
      LoggerService.log('Response Data: ${e.response?.data}');
      LoggerService.log('Get current user hatası, null döndürülüyor');
      return null;
    } catch (e) {
      LoggerService.error('Get current user genel hata', e);
      LoggerService.log('Get current user genel hatası, null döndürülüyor');
      return null;
    }
  }
}
