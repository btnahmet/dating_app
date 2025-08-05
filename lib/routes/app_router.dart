import 'package:go_router/go_router.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// Servis
import 'package:dating_app/core/services/navigation_service.dart';

// Sayfalar
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/register_screen.dart';
import '../features/auth/presentation/upload_photo_screen.dart';
import '../features/profile/presentation/profile_screen.dart';
import '../features/main/main_layout.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: NavigationService.navigatorKey,
    initialLocation: '/login',
    // Firebase Analytics observer'ı ekle
    observers: [
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
    ],
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/upload-photo',
        name: 'uploadPhoto',
        builder: (context, state) => const UploadPhotoScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainLayout(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
}
