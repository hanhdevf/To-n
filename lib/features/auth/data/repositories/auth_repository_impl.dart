import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/exceptions.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:galaxymob/features/auth/data/datasources/mock_auth_remote_data_source.dart';
import 'package:galaxymob/features/auth/domain/entities/user.dart';
import 'package:galaxymob/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final MockAuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Call remote data source
      final userModel = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // Save token (mock token based on user id)
      await localDataSource.saveAuthToken('mock_token_${userModel.id}');

      // Save user  data
      await localDataSource.saveCurrentUser(userModel);

      // Return user entity
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
      // Call remote data source
      final userModel = await remoteDataSource.register(
        email: email,
        password: password,
        displayName: displayName,
      );

      // Save token
      await localDataSource.saveAuthToken('mock_token_${userModel.id}');

      // Save user data
      await localDataSource.saveCurrentUser(userModel);

      // Return user entity
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
      // Get user from local storage
      final userModel = localDataSource.getCurrentUser();

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
      // Clear local data
      await localDataSource.clearAuthData();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return localDataSource.isLoggedIn();
  }
}
