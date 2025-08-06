# SinFlix - Dating App

Modern ve kullanıcı dostu bir dating uygulaması. Flutter ile geliştirilmiş, Firebase entegrasyonu ile güçlendirilmiş ve responsive tasarım ile optimize edilmiş.

##  İçindekiler

- [Özellikler](#-özellikler)
- [Teknolojiler](#-teknolojiler)
- [Kurulum](#-kurulum)
- [Proje Yapısı](#-proje-yapısı)
- [Firebase Entegrasyonu](#-firebase-entegrasyonu)
- [State Management](#-state-management)
- [API Entegrasyonu](#-api-entegrasyonu)
- [Responsive Tasarım](#-responsive-tasarım)
- [Localization](#-localization)
- [Test](#-test)
- [Deployment](#-deployment)

##  Özellikler

###  Kimlik Doğrulama
- **Kullanıcı Kaydı**: Email, şifre ve isim ile kayıt ve bu bilgilerin görüntülenmesi
- **Giriş Yapma**: Güvenli token tabanlı kimlik doğrulama
- **Profil Fotoğrafı**: Kullanıcı profil fotoğrafı yükleme
- **Güvenli Token Saklama**: Flutter Secure Storage ile güvenli token yönetimi
- **Kullanıcı girişi ve kayıt işlevselliği implementasyon**
- **Başarılı girişte otomatik ana sayfa yönlendirmesi**

### Ana Sayfa Özellikleri
- **Sonsuz kaydırma (Infinite scroll) implementasyon**
- **Her sayfada 5 film gösterim**
- **Otomatik yükleme gösterges**
- **Pull-to-refresh özelliğ**
- **Favori film işlemlerinde anlık UI güncellemesi**


###  Film Özellikleri
- **Film Listesi**: Sayfalama ile film listesi görüntüleme
- **Film Beğenme**: Filmleri beğenme/beğenmeme
- **Favori Filmler**: Beğenilen filmlerin listesi
- **Pull-to-Refresh**: Aşağı çekerek yenileme

###  Profil Yönetimi
- **Profil Görüntüleme**: Kullanıcı bilgileri ve fotoğrafı
- **Dil Değiştirme**: Türkçe/İngilizce dil desteği
- **Çıkış Yapma**: Güvenli oturum kapatma
- **Profil fotoğrafı yükleme özelliği**


###  Analytics & Monitoring
- **Firebase Analytics**: Kullanıcı davranışları takibi
- **Firebase Crashlytics**: Hata raporlama ve izleme
- **Custom Events**: Özel analitik event'leri

### Navigasyon
- **Bottom Navigation Bar ile sayfa geçişler**
- **Ana sayfa state yönetimi ve korunması**
- **Temel Gereksinimler**

### Kod Yapısı
- **Clean Architectur**
- **MVVM**
- **Bloc State Management**

###  Custom Theme

###  Navigation Service 

###  Localization
- **flutter_localizations**: SDK - Çoklu dil desteği

### Logger Service

## Güvenli Token Saklama ve Yönetimi

### Animasyon İmplementasyonu (Lottie)
![Movie Loading](https://github.com/user-attachments/assets/149ed5f9-81b1-4aaf-9e8b-d6b6af8a5e36)
![No Data](https://github.com/user-attachments/assets/1aa94130-786d-46dd-b624-9bccf4b055b1)

### Splash Screen ve Uygulama İkonu
<img width="374" height="844" alt="Ekran görüntüsü 2025-08-06 091550" src="https://github.com/user-attachments/assets/63949934-0625-4b1d-9a51-9d97eef5dbc7" />
<img width="374" height="844" alt="image" src="https://github.com/user-attachments/assets/3d7107d1-33ef-449a-8054-b29bb51a1303" />


##  Teknolojiler

### Core Framework
- **Flutter**: 3.24.0
- **Dart**: 3.4.0

### State Management
- **flutter_bloc**: ^8.1.3 - Bloc pattern implementasyonu
- **provider**: ^6.1.1 - Dependency injection

### Network & API
- **dio**: ^5.4.0 - HTTP client
- **flutter_secure_storage**: ^9.0.0 - Güvenli token saklama

### Firebase


## Kurulum

### Gereksinimler
- Flutter SDK 3.24.0+
- Dart 3.4.0+
- Android Studio / VS Code
- Git

### Adım 1: Projeyi Klonlayın
```bash
git clone https://github.com/btnahmet/dating_app.git
cd dating_app
```

### Adım 2: Bağımlılıkları Yükleyin
```bash
flutter pub get
```

### Adım 3: Firebase Kurulumu
1. [Firebase Console](https://console.firebase.google.com/) açın
2. Yeni proje oluşturun: `sinflixapp-3fb29`
3. Android uygulaması ekleyin:
   - Package name: `com.example.dating_app`
   - `google-services.json` dosyasını indirin
   - `android/app/google-services.json` konumuna koyun

### Adım 4: Uygulamayı Çalıştırın
```bash
# Debug modda çalıştır
flutter run --debug

# Release modda çalıştır
flutter run --release
```

## Proje Yapısı

```
lib/
├── main.dart                          # Uygulama giriş noktası
├── app.dart                           # Ana uygulama widget'ı
├── firebase_options.dart              # Firebase konfigürasyonu
├── core/                              # Core servisler
│   ├── architecture/
│   │   └── app_structure.dart        # Uygulama mimarisi
│   ├── services/
│   │   ├── api_service.dart          # API servisi
│   │   ├── firebase_service.dart     # Firebase servisi
│   │   ├── logger_service.dart       # Logging servisi
│   │   ├── navigation_service.dart   # Navigation servisi
│   │   ├── token_storage_service.dart # Token saklama
│   │   └── analytics_service.dart    # Analytics servisi
│   └── theme/
│       └── app_theme.dart            # Uygulama teması
├── features/                          # Feature-based yapı
│   ├── auth/                         # Kimlik doğrulama
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_local_data_source.dart
│   │   │   │   └── auth_remote_data_source.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   ├── user_entity.dart
│   │   │   │   └── movie_entity.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       └── login_usecase.dart
│   │   └── presentation/
│   │       ├── blocs/
│   │       │   └── auth_bloc.dart   # Auth Bloc
│   │       ├── login_screen.dart    # Giriş ekranı
│   │       ├── register_screen.dart # Kayıt ekranı
│   │       └── upload_photo_screen.dart # Foto yükleme
│   ├── home/                         # Ana sayfa
│   │   ├── data/
│   │   │   └── movie_service.dart   # Film servisi
│   │   ├── model/
│   │   │   └── movie_model.dart     # Film modeli
│   │   ├── presentation/
│   │   │   └── home_screen.dart     # Ana sayfa UI
│   │   └── viewmodel/
│   │       └── home_view_model.dart # Home ViewModel
│   ├── profile/                      # Profil
│   │   └── presentation/
│   │       ├── profile_screen.dart  # Profil ekranı
│   │       └── widgets/
│   │           └── limited_offer_bottom_sheet.dart
│   ├── premium/                      # Premium özellikler
│   │   └── presentation/
│   │       └── widgets/
│   │           └── limited_offer_bottom_sheet.dart
│   └── main/                         # Ana layout
│       └── main_layout.dart         # Ana layout
├── routes/                           # Routing
│   └── app_router.dart              # GoRouter konfigürasyonu
├── widgets/                          # Ortak widget'lar
│   ├── custom_button.dart           # Özel buton
│   ├── custom_text_field.dart       # Özel text field
│   └── locale_provider.dart         # Dil provider'ı
└── l10n/                            # Localization
  
```
<img width="395" height="841" alt="Ekran görüntüsü 2025-08-06 091621" src="https://github.com/user-attachments/assets/b3f0dc13-ecd1-4feb-8955-09dc49a82dc8" />
<img width="393" height="847" alt="Ekran görüntüsü 2025-08-06 091633" src="https://github.com/user-attachments/assets/570566e6-501f-433e-9bc8-645f0d5dead1" />
<img width="383" height="797" alt="Ekran görüntüsü 2025-08-06 092802" src="https://github.com/user-attachments/assets/85942e31-252e-494e-b1a9-ebd3b61d71bb" />
<img width="387" height="798" alt="Ekran görüntüsü 2025-08-06 091755" src="https://github.com/user-attachments/assets/bfb4f5f3-d9e4-426e-98fb-2814c2bbdd59" />
<img width="374" height="789" alt="Ekran görüntüsü 2025-08-06 092752" src="https://github.com/user-attachments/assets/fc426e69-f814-4618-999d-f40ca9419b4d" />
<img width="385" height="815" alt="Ekran görüntüsü 2025-08-06 091830" src="https://github.com/user-attachments/assets/2d985065-c173-4d9d-82a5-d0e606e3716e" />
<img width="388" height="810" alt="Ekran görüntüsü 2025-08-06 091907" src="https://github.com/user-attachments/assets/135c783c-15d1-47ad-8c58-1ad9c1a64f62" />
<img width="388" height="810" alt="image" src="https://github.com/user-attachments/assets/084b0ce0-d749-40ba-8e4b-25e372e1baf0" />

##  BLoC State Management

```dart 
Uygulama, Flutter BLoC pattern'ini kullanarak state management sağlar:
Event: Kullanıcı etkileşimleri ve sistem olayları
State: UI'ın gösterileceği durumlar
Bloc: Event'leri State'lere dönüştüren business logic

```


##  Responsive Tasarım

// MediaQuery Kullanımı
// Expanded Widget'ları
// Overflow Handling

## Localization

### Çeviri Dosyaları
```json
// app_tr.arb
// app_en.arb

### Kullanım
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.login)
```

## Test

### Firebase Analytics Test
1. Uygulamayı debug modda çalıştırın
2. Firebase Console → Analytics → DebugView açın
3. Uygulamada işlemler yapın
4. Event'lerin DebugView'da görünmesini kontrol edin

### Responsive Test
1. Farklı ekran boyutlarında test
2. Overflow kontrolü 
3. Text scaling testi

### API Test
1. Login/Register işlemleri
2. Film listesi yükleme testi
3. Foto yükleme testi

## Performans

### Monitoring
- **Firebase Analytics**: Kullanıcı davranışları
- **Firebase Crashlytics**: Hata izleme
- **Logger Service**: Detaylı loglama

## İletişim

- **Geliştirici**: [Ahmet BÜTÜN]
- **Email**: [ahmetbutun27@gmail.com]
- **GitHub**: [github.com/btnahmet]

---

**dating_app - SinFlix** - Modern dating uygulaması 
