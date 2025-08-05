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
}
