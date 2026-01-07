import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/auth/domain/usecases/get_current_user.dart';
import 'package:galaxymob/features/auth/domain/usecases/login_with_email.dart';
import 'package:galaxymob/features/auth/domain/usecases/login_with_google.dart';
import 'package:galaxymob/features/auth/domain/usecases/logout.dart';
import 'package:galaxymob/features/auth/domain/usecases/register_with_email.dart';
import 'package:galaxymob/features/auth/presentation/bloc/auth_event.dart';
import 'package:galaxymob/features/auth/presentation/bloc/auth_state.dart';

/// BLoC for handling authentication logic
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginWithEmail loginWithEmail;
  final LoginWithGoogle loginWithGoogle;
  final RegisterWithEmail registerWithEmail;
  final GetCurrentUser getCurrentUser;
  final Logout logout;

  AuthBloc({
    required this.loginWithEmail,
    required this.loginWithGoogle,
    required this.registerWithEmail,
    required this.getCurrentUser,
    required this.logout,
  }) : super(const AuthInitial()) {
    // Register event handlers
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginRequestedEvent>(_onLoginRequested);
    on<GoogleSignInRequestedEvent>(_onGoogleSignInRequested);
    on<RegisterRequestedEvent>(_onRegisterRequested);
    on<LogoutRequestedEvent>(_onLogoutRequested);
    on<LoadProfileEvent>(_onLoadProfile);

    // Auto-check auth status on initialization
    add(const CheckAuthStatusEvent());
  }

  /// Check if user is already logged in
  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await getCurrentUser(NoParams());

    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  /// Handle login request
  Future<void> _onLoginRequested(
    LoginRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await loginWithEmail(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  /// Handle Google Sign-In request
  Future<void> _onGoogleSignInRequested(
    GoogleSignInRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await loginWithGoogle(NoParams());

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  /// Handle register request
  Future<void> _onRegisterRequested(
    RegisterRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await registerWithEmail(
      RegisterParams(
        email: event.email,
        password: event.password,
        displayName: event.displayName,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  /// Handle logout request
  Future<void> _onLogoutRequested(
    LogoutRequestedEvent event,
    Emitter<AuthState> emit,
  ) async {
    await logout(NoParams());
    emit(const AuthUnauthenticated());
  }

  /// Load user profile
  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await getCurrentUser(NoParams());

    result.fold(
      (failure) {
        if (failure is AuthFailure) {
          emit(const AuthUnauthenticated());
        } else {
          emit(AuthError(failure.message));
        }
      },
      (user) => emit(ProfileLoaded(user)),
    );
  }
}
