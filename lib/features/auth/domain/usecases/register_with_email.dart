import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/auth/domain/entities/user.dart';
import 'package:galaxymob/features/auth/domain/repositories/auth_repository.dart';

/// Use case for registering new user
class RegisterWithEmail implements UseCase<User, RegisterParams> {
  final AuthRepository repository;

  RegisterWithEmail(this.repository);

  @override
  Future<Either<Failure, User>> call(RegisterParams params) async {
    return await repository.registerWithEmail(
      email: params.email,
      password: params.password,
      displayName: params.displayName,
    );
  }
}

/// Parameters for register use case
class RegisterParams extends Equatable {
  final String email;
  final String password;
  final String displayName;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.displayName,
  });

  @override
  List<Object?> get props => [email, password, displayName];
}
