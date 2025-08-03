import 'package:dating_app/widgets/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Core
import 'core/theme/app_theme.dart';
import 'core/services/logger_service.dart';

// Features
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/presentation/blocs/auth_bloc.dart';

// Home
import 'features/home/viewmodel/home_view_model.dart';

// Routes
import 'routes/app_router.dart';

void main() {
   WidgetsFlutterBinding.ensureInitialized();
  // Logger başlat (örnek: Crashlytics gibi future eklenecekse buraya)
  LoggerService.init(); // Logger sınıfı içinde static init metodu

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        // Dio instance
        RepositoryProvider<Dio>(
          create: (context) => Dio(
            BaseOptions(
              baseUrl: 'https://caseapi.servicelabs.tech',
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          ),
        ),

        // Local Storage
        RepositoryProvider<FlutterSecureStorage>(
          create: (context) => const FlutterSecureStorage(),
        ),

        // Data Sources
        RepositoryProvider<AuthLocalDataSource>(
          create: (context) => AuthLocalDataSourceImpl(
            context.read<FlutterSecureStorage>(),
          ),
        ),

        RepositoryProvider<AuthRemoteDataSource>(
          create: (context) => AuthRemoteDataSourceImpl(
            context.read<Dio>(),
          ),
        ),

        // Repositories
        RepositoryProvider<AuthRepositoryImpl>(
          create: (context) => AuthRepositoryImpl(
            remoteDataSource: context.read<AuthRemoteDataSource>(),
            localDataSource: context.read<AuthLocalDataSource>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // Auth Bloc
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepositoryImpl>(),
            ),
          ),
        ],
        child: MultiProvider(
          providers: [
            // Home ViewModel
            ChangeNotifierProvider(create: (_) => HomeViewModel()),
            ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ],
          child: Builder(
            builder: (context) {
              final localeProvider = Provider.of<LocaleProvider>(context);
              return MaterialApp.router(
                title: 'Dating App',
                theme: AppTheme.darkTheme,
                debugShowCheckedModeBanner: false,
                routerConfig: AppRouter.router,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [
                  Locale('en'),
                  Locale('tr'),
                ],
                locale: localeProvider.locale,
              );
            },
          ),
        ),
      ),
    );
  }
}
