import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/cinema/data/datasources/cinema_firestore_data_source.dart';
import 'package:galaxymob/features/cinema/domain/entities/cinema.dart';
import 'package:galaxymob/features/cinema/domain/entities/showtime.dart';
import 'package:galaxymob/features/cinema/domain/repositories/cinema_repository.dart';

/// Firestore implementation of CinemaRepository
class CinemaFirestoreRepositoryImpl implements CinemaRepository {
  final CinemaFirestoreDataSource dataSource;

  CinemaFirestoreRepositoryImpl({required this.dataSource});

  /// Helper method to get all cinemas (not part of interface)
  Future<Either<Failure, List<Cinema>>> getCinemas() async {
    try {
      final cinemaModels = await dataSource.getCinemas();
      final cinemas = cinemaModels.map((model) => model.toEntity()).toList();
      return Right(cinemas);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Cinema>>> getNearbyCinemas({
    double? latitude,
    double? longitude,
  }) async {
    // For simplicity, just return all cinemas
    // In a real app, you'd filter by distance
    return getCinemas();
  }

  @override
  Future<Either<Failure, Map<String, List<Showtime>>>> getShowtimes({
    required int movieId,
    required DateTime date,
  }) async {
    try {
      final showtimesByCinema = await dataSource.getShowtimes(
        movieId: movieId,
        date: date,
      );

      // Convert models to entities
      final Map<String, List<Showtime>> result = {};
      showtimesByCinema.forEach((cinemaId, showtimeModels) {
        result[cinemaId] =
            showtimeModels.map((model) => model.toEntity()).toList();
      });

      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Showtime>>> getCinemaShowtimes({
    required String cinemaId,
    required int movieId,
    required DateTime date,
  }) async {
    try {
      final allShowtimes = await dataSource.getShowtimes(
        movieId: movieId,
        date: date,
      );

      final cinemaShowtimes = allShowtimes[cinemaId] ?? [];
      final showtimes =
          cinemaShowtimes.map((model) => model.toEntity()).toList();

      return Right(showtimes);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
