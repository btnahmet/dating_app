import 'package:dio/dio.dart';
import 'token_storage_service.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://caseapi.servicelabs.tech",
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  ApiService() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await TokenStorageService().getToken();
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        return handler.next(options);
      },
    ));
  }

  Dio get dio => _dio;

  // Login API endpoint
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('Login API çağrısı başlatılıyor...');
      
      final response = await _dio.post('/user/login', data: {
        'email': email,
        'password': password,
      });
      
      print('Login API yanıtı: ${response.statusCode}');
      print('Login API verisi: ${response.data}');
      
      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Login başarısız');
      }
    } on DioException catch (e) {
      print('Login DioException: ${e.message}');
      print('Status Code: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');
      throw Exception('Login hatası: ${e.message}');
    } catch (e) {
      print('Login genel hata: $e');
      throw Exception('Login hatası: $e');
    }
  }

  // Register API endpoint
  Future<Map<String, dynamic>> register(String name, String email, String password) async {
    try {
      print('Register API çağrısı başlatılıyor...');
      
      final response = await _dio.post('/user/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      
      print('Register API yanıtı: ${response.statusCode}');
      print('Register API verisi: ${response.data}');
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Register başarılı, kullanıcı bilgilerini token'a ekle
        final data = response.data['data'] ?? response.data;
        if (data['token'] != null) {
          // Token'ı kaydet
          await TokenStorageService().saveToken(data['token']);
          print('Register sonrası token kaydedildi');
        }
        return response.data;
      } else {
        throw Exception('Kayıt başarısız');
      }
    } on DioException catch (e) {
      print('Register DioException: ${e.message}');
      print('Status Code: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');
      throw Exception('Kayıt hatası: ${e.message}');
    } catch (e) {
      print('Register genel hata: $e');
      throw Exception('Kayıt hatası: $e');
    }
  }

  // Logout API endpoint
  Future<void> logout() async {
    try {
      print('Logout API çağrısı başlatılıyor...');
      
      final response = await _dio.post('/user/logout');
      
      print('Logout API yanıtı: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        // Token'ı temizle
        await TokenStorageService().clearToken();
        print('Logout başarılı, token temizlendi');
      } else {
        throw Exception('Logout başarısız');
      }
    } on DioException catch (e) {
      print('Logout DioException: ${e.message}');
      // API hatası olsa bile token'ı temizle
      await TokenStorageService().clearToken();
      print('Logout API hatası, token temizlendi');
    } catch (e) {
      print('Logout genel hata: $e');
      // Genel hata olsa bile token'ı temizle
      await TokenStorageService().clearToken();
      print('Logout genel hata, token temizlendi');
    }
  }
}
