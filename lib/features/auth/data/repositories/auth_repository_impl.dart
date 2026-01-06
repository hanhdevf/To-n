import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/exceptions.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/auth/data/datasources/firebase_auth_service.dart';
import 'package:galaxymob/features/auth/domain/entities/user.dart';
import 'package:galaxymob/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository using Firebase Authentication
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService authService;

  AuthRepositoryImpl({
    required this.authService,
  });

  @override
  Future<Either<Failure, User>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await authService.loginWithEmail(
        email: email,
        password: password,
      );
      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    try {
      final userModel = await authService.registerWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> loginWithGoogle() async {
    try {
      final userModel = await authService.loginWithGoogle();
      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final userModel = authService.getCurrentUser();
      if (userModel == null) {
        return const Left(AuthFailure('No user logged in'));
      }
      return Right(userModel.toEntity());
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authService.logout();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return authService.isLoggedIn();
  }
}
