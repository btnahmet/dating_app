import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

// Events
abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  
  LoginEvent({required this.email, required this.password});
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  
  RegisterEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

class UploadPhotoEvent extends AuthEvent {
  final String photoPath;
  
  UploadPhotoEvent({required this.photoPath});
}

class LogoutEvent extends AuthEvent {}

// States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserEntity user;
  
  AuthSuccess({required this.user});
}

class AuthError extends AuthState {
  final String message;
  
  AuthError({required this.message});
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
      final user = await authRepository.login(event.email, event.password);
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      final user = await authRepository.register(event.name, event.email, event.password);
      emit(AuthSuccess(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onUploadPhoto(UploadPhotoEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      await authRepository.uploadPhoto(event.photoPath);
      // Refresh user data after photo upload
      final currentUser = await authRepository.getCurrentUser();
      if (currentUser != null) {
        emit(AuthSuccess(user: currentUser));
      } else {
        emit(AuthError(message: 'Kullanıcı bilgileri alınamadı'));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    try {
      await authRepository.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  // Helper method for upload photo
  Future<void> uploadPhoto(String photoPath) async {
    add(UploadPhotoEvent(photoPath: photoPath));
  }
} 