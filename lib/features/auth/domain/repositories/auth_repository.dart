import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/auth/domain/entities/user.dart';

/// Repository interface for authentication operations
abstract class AuthRepository {
  /// Login with email and password
  Future<Either<Failure, User>> loginWithEmail({
    required String email,
    required String password,
  });

  /// Register new user with email, password, and display name
  Future<Either<Failure, User>> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  });

  /// Get currently logged in user
  Future<Either<Failure, User>> getCurrentUser();

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Check if user is logged in
  Future<bool> isLoggedIn();

  /// Login with Google account
  Future<Either<Failure, User>> loginWithGoogle();
}
