import 'package:dating_app/features/auth/presentation/login_screen.dart';
import 'package:dating_app/features/auth/presentation/register_screen.dart';
import 'package:dating_app/features/auth/presentation/upload_photo_screen.dart';
import 'package:dating_app/features/home/presentation/home_screen.dart';
import 'package:dating_app/features/main/main_layout.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainLayout(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/upload',
        builder: (context, state) => const UploadPhotoScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      // GoRoute(
      //   path: '/profile',
      //   builder: (context, state) => const ProfileScreen(),
      // ),
    ],
  );
}
