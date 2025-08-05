import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Kullanıcı girişi
  static Future<void> logLogin() async {
    await _analytics.logEvent(name: 'user_login');
  }

  // Kullanıcı kaydı
  static Future<void> logRegister() async {
    await _analytics.logEvent(name: 'user_register');
  }

  // Fotoğraf yükleme
  static Future<void> logPhotoUpload() async {
    await _analytics.logEvent(name: 'photo_upload');
  }

  // Profil görüntüleme
  static Future<void> logProfileView() async {
    await _analytics.logEvent(name: 'profile_view');
  }

  // Ana sayfa görüntüleme
  static Future<void> logHomeView() async {
    await _analytics.logEvent(name: 'home_view');
  }

  // Film favori ekleme
  static Future<void> logMovieFavorite() async {
    await _analytics.logEvent(name: 'movie_favorite');
  }

  // Film favori kaldırma
  static Future<void> logMovieUnfavorite() async {
    await _analytics.logEvent(name: 'movie_unfavorite');
  }

  // Dil değiştirme
  static Future<void> logLanguageChange(String language) async {
    await _analytics.logEvent(
      name: 'language_change',
      parameters: {'language': language},
    );
  }

  // Premium teklif görüntüleme
  static Future<void> logPremiumOfferView() async {
    await _analytics.logEvent(name: 'premium_offer_view');
  }

  // Premium teklif tıklama
  static Future<void> logPremiumOfferClick() async {
    await _analytics.logEvent(name: 'premium_offer_click');
  }

  // Çıkış yapma
  static Future<void> logLogout() async {
    await _analytics.logEvent(name: 'user_logout');
  }

  // Özel event gönderme
  static Future<void> logCustomEvent(String eventName, [Map<String, dynamic>? parameters]) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: parameters,
    );
  }

  // Kullanıcı özelliklerini ayarlama
  static Future<void> setUserProperties({
    String? userId,
    String? userEmail,
    String? userLanguage,
  }) async {
    if (userId != null) {
      await _analytics.setUserId(id: userId);
    }
    if (userEmail != null) {
      await _analytics.setUserProperty(name: 'user_email', value: userEmail);
    }
    if (userLanguage != null) {
      await _analytics.setUserProperty(name: 'user_language', value: userLanguage);
    }
  }
} 