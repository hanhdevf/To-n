import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/auth/domain/entities/user.dart';
import 'package:galaxymob/features/auth/domain/repositories/auth_repository.dart';

/// UseCase for logging in with Google account
class LoginWithGoogle implements UseCase<User, NoParams> {
  final AuthRepository repository;

  LoginWithGoogle(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.loginWithGoogle();
  }
}
