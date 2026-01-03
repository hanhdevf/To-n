import 'package:equatable/equatable.dart';
import 'package:galaxymob/features/auth/domain/entities/user.dart';

/// Authentication Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Check if user is already logged in
class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}

/// Login with email and password
class LoginRequestedEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginRequestedEvent({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Register new user
class RegisterRequestedEvent extends AuthEvent {
  final String email;
  final String password;
  final String displayName;

  const RegisterRequestedEvent({
    required this.email,
    required this.password,
    required this.displayName,
  });

  @override
  List<Object?> get props => [email, password, displayName];
}

/// Logout current user
class LogoutRequestedEvent extends AuthEvent {
  const LogoutRequestedEvent();
}

/// Load user profile
class LoadProfileEvent extends AuthEvent {
  const LoadProfileEvent();
}
