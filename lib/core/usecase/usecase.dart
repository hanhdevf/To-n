import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:galaxymob/core/error/failures.dart';

/// Base class for all use cases in the application
///
/// [Type] is the type of data returned by the use case
/// [Params] is the type of parameters required by the use case
abstract class UseCase<Type, Params> {
  /// Execute the use case
  ///
  /// Returns [Either] with [Failure] on the left or [Type] on the right
  Future<Either<Failure, Type>> call(Params params);
}

/// Class to be used when a use case doesn't require any parameters
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
