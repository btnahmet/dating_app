import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/services/logger_service.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  
  const LoginEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  
  const RegisterEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

class UploadPhotoEvent extends AuthEvent {
  final String photoPath;
  
  const UploadPhotoEvent({required this.photoPath});

  @override
  List<Object?> get props => [photoPath];
}

class LogoutEvent extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserEntity user;
  
  const AuthSuccess({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthError extends AuthState {
  final String message;
  
  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<UploadPhotoEvent>(_onUploadPhoto);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      LoggerService.log('Login işlemi başlatıldı: ${event.email}');
      final user = await authRepository.login(event.email, event.password);
      LoggerService.log('Login başarılı: ${user.name}');
      emit(AuthSuccess(user: user));
    } catch (e) {
      LoggerService.error('Login hatası: $e');
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      LoggerService.log('Register işlemi başlatıldı: ${event.email}');
      final user = await authRepository.register(event.name, event.email, event.password);
      LoggerService.log('Register başarılı: ${user.name}');
      emit(AuthSuccess(user: user));
    } catch (e) {
      LoggerService.error('Register hatası: $e');
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onUploadPhoto(UploadPhotoEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      LoggerService.log('Fotoğraf yükleme başlatıldı: ${event.photoPath}');
      await authRepository.uploadPhoto(event.photoPath);
      
      // Refresh user data after photo upload
      final currentUser = await authRepository.getCurrentUser();
      if (currentUser != null) {
        LoggerService.log('Fotoğraf yükleme başarılı');
        emit(AuthSuccess(user: currentUser));
      } else {
        LoggerService.error('Kullanıcı bilgileri alınamadı');
        emit(AuthError(message: 'Kullanıcı bilgileri alınamadı'));
      }
    } catch (e) {
      LoggerService.error('Fotoğraf yükleme hatası: $e');
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      LoggerService.log('Logout işlemi başlatıldı');
      await authRepository.logout();
      LoggerService.log('Logout başarılı');
      emit(AuthInitial());
    } catch (e) {
      LoggerService.error('Logout hatası: $e');
      emit(AuthError(message: e.toString()));
    }
  }

  // Helper method for upload photo
  Future<void> uploadPhoto(String photoPath) async {
    add(UploadPhotoEvent(photoPath: photoPath));
  }
} 