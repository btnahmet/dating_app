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

  // Login API endpoint - farklı endpoint'leri deniyoruz
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('Login API çağrısı başlatılıyor...');
      
      // Sadece çalışan endpoint'i kullan
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
}
