import 'package:dio/dio.dart';
import 'token_storage_service.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: "https://caseapi.servicelabs.tech/api/"));

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
}
