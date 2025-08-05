import 'package:dio/dio.dart';
import '../../../core/services/token_storage_service.dart';
import '../../../core/services/logger_service.dart';
import '../model/movie_model.dart';

class MovieService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://caseapi.servicelabs.tech',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));
  
  final TokenStorageService _tokenStorage = TokenStorageService();

  Future<List<MovieModel>> fetchMovies({int page = 1}) async {
    try {
      LoggerService.log('API çağrısı başlatılıyor...');
      
      // Token'ı al
      final token = await _tokenStorage.getToken();
      LoggerService.log('Token alındı: ${token != null ? 'Mevcut' : 'Yok'}');
      
      // Request options oluştur
      final options = Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      // Token varsa header'a ekle, yoksa test token'ı kullan
      if (token != null) {
        options.headers!['Authorization'] = 'Bearer $token';
        LoggerService.log('Authorization header eklendi: Bearer $token');
      } else {
        // Test için geçici token (gerçek token'ınızla değiştirin)
        options.headers!['Authorization'] = 'Bearer test_token_here';
        LoggerService.log('Test token kullanılıyor');
      }
      
      // Farklı parametrelerle deneme
      final response = await _dio.get('/movie/list', 
        queryParameters: {
          'page': page,
          'limit': 10,
        },
        options: options,
      );
      
      LoggerService.log('API yanıtı alındı: ${response.statusCode}');
      LoggerService.log('API yanıt verisi: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        final data = responseData['data'];
        final moviesList = data['movies'] as List;
        
        LoggerService.log('Film sayısı: ${moviesList.length}');
        final movies = moviesList.map((e) => MovieModel.fromJson(e)).toList();
        LoggerService.log('Dönüştürülen film sayısı: ${movies.length}');
        
        // Film ID'lerini debug et
        for (int i = 0; i < movies.length; i++) {
          LoggerService.log('Film $i - ID: ${movies[i].id}, Title: ${movies[i].title}');
        }
        
        return movies;
      } else {
        LoggerService.log('API yanıt kodu hatalı: ${response.statusCode}');
        throw Exception('Filmler alınamadı');
      }
    } on DioException catch (e) {
      LoggerService.error('DioException', e);
      LoggerService.log('Status Code: ${e.response?.statusCode}');
      LoggerService.log('Response Data: ${e.response?.data}');
      LoggerService.log('Request URL: ${e.requestOptions.uri}');
      LoggerService.log('Request Headers: ${e.requestOptions.headers}');
      throw Exception('API Hatası: ${e.message}');
    } catch (e) {
      LoggerService.error('Genel hata', e);
      throw Exception('Hata: $e');
    }
  }

  // Film beğenme/beğenmeme
  Future<bool> toggleFavorite(String movieId) async {
    try {
      LoggerService.log('MovieService: Film beğeni işlemi başlatılıyor... Movie ID: $movieId');
      LoggerService.log('MovieService: Movie ID tipi: ${movieId.runtimeType}');
      LoggerService.log('MovieService: Movie ID boş mu: ${movieId.isEmpty}');
      
      final token = await _tokenStorage.getToken();
      LoggerService.log('MovieService: Token alındı: ${token != null ? 'Mevcut' : 'Yok'}');
      if (token != null) {
        LoggerService.log('MovieService: Token uzunluğu: ${token.length}');
        LoggerService.log('MovieService: Token başlangıcı: ${token.substring(0, 20)}...');
      }
      
      if (token == null) {
        LoggerService.log('MovieService: Token bulunamadı, beğeni işlemi iptal ediliyor');
        throw Exception('Token bulunamadı');
      }

      if (movieId.isEmpty) {
        LoggerService.log('MovieService: Movie ID boş, beğeni işlemi iptal ediliyor');
        throw Exception('Movie ID boş');
      }

      LoggerService.log('MovieService: API çağrısı yapılıyor... URL: /movie/favorite/$movieId');
      LoggerService.log('MovieService: Full URL: https://caseapi.servicelabs.tech/movie/favorite/$movieId');
      
      final response = await _dio.post('/movie/favorite/$movieId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      
      LoggerService.log('MovieService: Beğeni API yanıtı: ${response.statusCode}');
      LoggerService.log('MovieService: Beğeni API verisi: ${response.data}');

      if (response.statusCode == 200) {
        LoggerService.log('MovieService: Beğeni işlemi başarılı');
        return true;
      } else {
        LoggerService.log('MovieService: Beğeni işlemi başarısız - Status: ${response.statusCode}');
        throw Exception('Beğeni işlemi başarısız');
      }
    } on DioException catch (e) {
      LoggerService.error('MovieService: Beğeni DioException', e);
      LoggerService.log('MovieService: Status Code: ${e.response?.statusCode}');
      LoggerService.log('MovieService: Response Data: ${e.response?.data}');
      LoggerService.log('MovieService: Request URL: ${e.requestOptions.uri}');
      LoggerService.log('MovieService: Request Headers: ${e.requestOptions.headers}');
      throw Exception('Beğeni hatası: ${e.message}');
    } catch (e) {
      LoggerService.error('MovieService: Beğeni genel hata', e);
      throw Exception('Beğeni hatası: $e');
    }
  }

  // Beğenilen filmleri getir
  Future<List<MovieModel>> fetchFavoriteMovies() async {
    try {
      LoggerService.log('Beğenilen filmler getiriliyor...');
      
      final token = await _tokenStorage.getToken();
      if (token == null) {
        throw Exception('Token bulunamadı');
      }

      final response = await _dio.get('/movie/favorites',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      
      LoggerService.log('Beğenilen filmler API yanıtı: ${response.statusCode}');
      LoggerService.log('Beğenilen filmler API verisi: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        final data = responseData['data'];
        
        // API yanıt formatını kontrol et
        LoggerService.log('Beğenilen filmler data yapısı: $data');
        
        List<dynamic> moviesList;
        if (data is List) {
          // Direkt liste olarak geliyor
          moviesList = data;
          LoggerService.log('Beğenilen filmler direkt liste olarak alındı');
        } else if (data is Map && data.containsKey('movies')) {
          // movies key'i ile geliyor
          moviesList = data['movies'] as List;
          LoggerService.log('Beğenilen filmler movies key ile alındı');
        } else {
          LoggerService.log('Beğenilen filmler beklenmeyen format: $data');
          return [];
        }
        
        LoggerService.log('Beğenilen film sayısı: ${moviesList.length}');
        final movies = moviesList.map((e) => MovieModel.fromJson(e)).toList();
        LoggerService.log('Dönüştürülen beğenilen film sayısı: ${movies.length}');
        return movies;
      } else {
        LoggerService.log('Beğenilen filmler API yanıt kodu hatalı: ${response.statusCode}');
        throw Exception('Beğenilen filmler alınamadı');
      }
    } on DioException catch (e) {
      LoggerService.error('Beğenilen filmler DioException', e);
      LoggerService.log('Status Code: ${e.response?.statusCode}');
      LoggerService.log('Response Data: ${e.response?.data}');
      throw Exception('Beğenilen filmler hatası: ${e.message}');
    } catch (e) {
      LoggerService.error('Beğenilen filmler genel hata', e);
      throw Exception('Beğenilen filmler hatası: $e');
    }
  }
}
