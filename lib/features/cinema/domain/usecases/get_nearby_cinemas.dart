import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/cinema/domain/entities/cinema.dart';
import 'package:galaxymob/features/cinema/domain/repositories/cinema_repository.dart';

/// Use case for getting nearby cinemas
class GetNearbyCinemas implements UseCase<List<Cinema>, LocationParams> {
  final CinemaRepository repository;

  GetNearbyCinemas(this.repository);

  @override
  Future<Either<Failure, List<Cinema>>> call(LocationParams params) async {
    return await repository.getNearbyCinemas(
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}

/// Parameters for location-based queries
class LocationParams extends Equatable {
  final double? latitude;
  final double? longitude;

  const LocationParams({
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}
