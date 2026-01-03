import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/cinema/data/datasources/mock_cinema_data_source.dart';
import 'package:galaxymob/features/cinema/domain/entities/cinema.dart';
import 'package:galaxymob/features/cinema/domain/entities/showtime.dart';
import 'package:galaxymob/features/cinema/domain/repositories/cinema_repository.dart';

/// Implementation of CinemaRepository using mock data
class CinemaRepositoryImpl implements CinemaRepository {
  final MockCinemaDataSource dataSource;

  CinemaRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<Cinema>>> getNearbyCinemas({
    double? latitude,
    double? longitude,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      final cinemas = dataSource.getMockCinemas();

      // Sort by distance if location provided
      if (latitude != null && longitude != null) {
        cinemas.sort((a, b) {
          final distA = a.distanceFrom(latitude, longitude);
          final distB = b.distanceFrom(latitude, longitude);
          return distA.compareTo(distB);
        });
      }

      return Right(cinemas);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, List<Showtime>>>> getShowtimes({
    required int movieId,
    required DateTime date,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      final showtimes = dataSource.getAllShowtimes(
        movieId: movieId,
        date: date,
      );

      return Right(showtimes);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Showtime>>> getCinemaShowtimes({
    required String cinemaId,
    required int movieId,
    required DateTime date,
  }) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      final showtimes = dataSource.generateShowtimes(
        cinemaId: cinemaId,
        movieId: movieId,
        date: date,
      );

      return Right(showtimes);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
