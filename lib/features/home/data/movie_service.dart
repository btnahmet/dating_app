import 'package:dio/dio.dart';
import '../../../core/services/token_storage_service.dart';
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
      print('API çağrısı başlatılıyor...');
      
      // Token'ı al
      final token = await _tokenStorage.getToken();
      print('Token alındı: ${token != null ? 'Mevcut' : 'Yok'}');
      
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
        print('Authorization header eklendi: Bearer $token');
      } else {
        // Test için geçici token (gerçek token'ınızla değiştirin)
        options.headers!['Authorization'] = 'Bearer test_token_here';
        print('Test token kullanılıyor');
      }
      
      // Farklı parametrelerle deneme
      final response = await _dio.get('/movie/list', 
        queryParameters: {
          'page': page,
          'limit': 10,
        },
        options: options,
      );
      
      print('API yanıtı alındı: ${response.statusCode}');
      print('API yanıt verisi: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        final data = responseData['data'];
        final moviesList = data['movies'] as List;
        
        print('Film sayısı: ${moviesList.length}');
        final movies = moviesList.map((e) => MovieModel.fromJson(e)).toList();
        print('Dönüştürülen film sayısı: ${movies.length}');
        
        // Film ID'lerini debug et
        for (int i = 0; i < movies.length; i++) {
          print('Film $i - ID: ${movies[i].id}, Title: ${movies[i].title}');
        }
        
        return movies;
      } else {
        print('API yanıt kodu hatalı: ${response.statusCode}');
        throw Exception('Filmler alınamadı');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      print('Status Code: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');
      print('Request URL: ${e.requestOptions.uri}');
      print('Request Headers: ${e.requestOptions.headers}');
      throw Exception('API Hatası: ${e.message}');
    } catch (e) {
      print('Genel hata: $e');
      throw Exception('Hata: $e');
    }
  }

  // Film beğenme/beğenmeme
  Future<bool> toggleFavorite(String movieId) async {
    try {
      print('MovieService: Film beğeni işlemi başlatılıyor... Movie ID: $movieId');
      print('MovieService: Movie ID tipi: ${movieId.runtimeType}');
      print('MovieService: Movie ID boş mu: ${movieId.isEmpty}');
      
      final token = await _tokenStorage.getToken();
      print('MovieService: Token alındı: ${token != null ? 'Mevcut' : 'Yok'}');
      if (token != null) {
        print('MovieService: Token uzunluğu: ${token.length}');
        print('MovieService: Token başlangıcı: ${token.substring(0, 20)}...');
      }
      
      if (token == null) {
        print('MovieService: Token bulunamadı, beğeni işlemi iptal ediliyor');
        throw Exception('Token bulunamadı');
      }

      if (movieId.isEmpty) {
        print('MovieService: Movie ID boş, beğeni işlemi iptal ediliyor');
        throw Exception('Movie ID boş');
      }

      print('MovieService: API çağrısı yapılıyor... URL: /movie/favorite/$movieId');
      print('MovieService: Full URL: https://caseapi.servicelabs.tech/movie/favorite/$movieId');
      
      final response = await _dio.post('/movie/favorite/$movieId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      
      print('MovieService: Beğeni API yanıtı: ${response.statusCode}');
      print('MovieService: Beğeni API verisi: ${response.data}');

      if (response.statusCode == 200) {
        print('MovieService: Beğeni işlemi başarılı');
        return true;
      } else {
        print('MovieService: Beğeni işlemi başarısız - Status: ${response.statusCode}');
        throw Exception('Beğeni işlemi başarısız');
      }
    } on DioException catch (e) {
      print('MovieService: Beğeni DioException: ${e.message}');
      print('MovieService: Status Code: ${e.response?.statusCode}');
      print('MovieService: Response Data: ${e.response?.data}');
      print('MovieService: Request URL: ${e.requestOptions.uri}');
      print('MovieService: Request Headers: ${e.requestOptions.headers}');
      throw Exception('Beğeni hatası: ${e.message}');
    } catch (e) {
      print('MovieService: Beğeni genel hata: $e');
      throw Exception('Beğeni hatası: $e');
    }
  }

  // Beğenilen filmleri getir
  Future<List<MovieModel>> fetchFavoriteMovies() async {
    try {
      print('Beğenilen filmler getiriliyor...');
      
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
      
      print('Beğenilen filmler API yanıtı: ${response.statusCode}');
      print('Beğenilen filmler API verisi: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        final data = responseData['data'];
        
        // API yanıt formatını kontrol et
        print('Beğenilen filmler data yapısı: $data');
        
        List<dynamic> moviesList;
        if (data is List) {
          // Direkt liste olarak geliyor
          moviesList = data;
          print('Beğenilen filmler direkt liste olarak alındı');
        } else if (data is Map && data.containsKey('movies')) {
          // movies key'i ile geliyor
          moviesList = data['movies'] as List;
          print('Beğenilen filmler movies key ile alındı');
        } else {
          print('Beğenilen filmler beklenmeyen format: $data');
          return [];
        }
        
        print('Beğenilen film sayısı: ${moviesList.length}');
        final movies = moviesList.map((e) => MovieModel.fromJson(e)).toList();
        print('Dönüştürülen beğenilen film sayısı: ${movies.length}');
        return movies;
      } else {
        print('Beğenilen filmler API yanıt kodu hatalı: ${response.statusCode}');
        throw Exception('Beğenilen filmler alınamadı');
      }
    } on DioException catch (e) {
      print('Beğenilen filmler DioException: ${e.message}');
      print('Status Code: ${e.response?.statusCode}');
      print('Response Data: ${e.response?.data}');
      throw Exception('Beğenilen filmler hatası: ${e.message}');
    } catch (e) {
      print('Beğenilen filmler genel hata: $e');
      throw Exception('Beğenilen filmler hatası: $e');
    }
  }
}
