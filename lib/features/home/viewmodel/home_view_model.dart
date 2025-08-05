import 'package:flutter/material.dart';
import '../data/movie_service.dart';
import '../model/movie_model.dart';
import '../../../core/services/logger_service.dart';

class HomeViewModel extends ChangeNotifier {
  final MovieService _movieService = MovieService();

  List<MovieModel> movies = [];
  List<MovieModel> favoriteMovies = [];
  bool isLoading = false;
  bool isLoadingFavorites = false;
  int currentPage = 1;

  Future<void> loadMovies() async {
    LoggerService.log('HomeViewModel: Film yükleme başlatılıyor...');
    isLoading = true;
    notifyListeners();

    try {
      final newMovies = await _movieService.fetchMovies(page: currentPage);
      LoggerService.log('HomeViewModel: ${newMovies.length} film alındı');
      movies.addAll(newMovies);
      currentPage++;
      LoggerService.log('HomeViewModel: Toplam film sayısı: ${movies.length}');
    } catch (e) {
      LoggerService.error('HomeViewModel: Film yükleme hatası', e);
    }

    isLoading = false;
    notifyListeners();
    LoggerService.log('HomeViewModel: Film yükleme tamamlandı');
  }

  Future<void> refreshMovies() async {
    LoggerService.log('HomeViewModel: Film yenileme başlatılıyor...');
    isLoading = true;
    currentPage = 1;
    notifyListeners();

    try {
      final newMovies = await _movieService.fetchMovies(page: currentPage);
      LoggerService.log('HomeViewModel: Yenileme - ${newMovies.length} film alındı');
      movies = newMovies;
      currentPage++;
    } catch (e) {
      LoggerService.error('HomeViewModel: Film yenileme hatası', e);
    }

    isLoading = false;
    notifyListeners();
    LoggerService.log('HomeViewModel: Film yenileme tamamlandı');
  }

  Future<void> loadMore() async {
    if (isLoading) return;

    await loadMovies();
  }

  // Film beğenme/beğenmeme
  Future<void> toggleFavorite(String movieId) async {
    try {
      LoggerService.log('HomeViewModel: Film beğeni işlemi başlatılıyor... Movie ID: $movieId');
      LoggerService.log('HomeViewModel: Mevcut beğenilen film sayısı: ${favoriteMovies.length}');
      
      final success = await _movieService.toggleFavorite(movieId);
      
      if (success) {
        LoggerService.log('HomeViewModel: Film beğeni işlemi başarılı');
        
        // UI'ı hemen güncelle
        final movie = movies.firstWhere((m) => m.id == movieId, orElse: () => MovieModel(id: '', title: '', description: '', posterUrl: ''));
        if (movie.id.isNotEmpty) {
          if (isFavorite(movieId)) {
            // Beğeniyi kaldır
            favoriteMovies.removeWhere((m) => m.id == movieId);
            LoggerService.log('HomeViewModel: Film beğenilerden kaldırıldı');
          } else {
            // Beğeniye ekle
            favoriteMovies.add(movie);
            LoggerService.log('HomeViewModel: Film beğenilere eklendi');
          }
          notifyListeners();
        }
        
        // Beğenilen filmleri yenile
        await loadFavoriteMovies();
        LoggerService.log('HomeViewModel: Beğenilen filmler yenilendi');
      } else {
        LoggerService.log('HomeViewModel: Film beğeni işlemi başarısız');
      }
    } catch (e) {
      LoggerService.error('HomeViewModel: Film beğeni hatası', e);
    }
  }

  // Beğenilen filmleri yükle
  Future<void> loadFavoriteMovies() async {
    LoggerService.log('HomeViewModel: Beğenilen filmler yükleniyor...');
    isLoadingFavorites = true;
    notifyListeners();

    try {
      final favorites = await _movieService.fetchFavoriteMovies();
      LoggerService.log('HomeViewModel: ${favorites.length} beğenilen film alındı');
      favoriteMovies = favorites;
    } catch (e) {
      LoggerService.error('HomeViewModel: Beğenilen filmler yükleme hatası', e);
      favoriteMovies = [];
    }

    isLoadingFavorites = false;
    notifyListeners();
    LoggerService.log('HomeViewModel: Beğenilen filmler yükleme tamamlandı');
  }

  // Film beğeniliyor mu kontrol et
  bool isFavorite(String movieId) {
    return favoriteMovies.any((movie) => movie.id == movieId);
  }
}
