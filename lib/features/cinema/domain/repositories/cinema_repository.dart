import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/cinema/domain/entities/cinema.dart';
import 'package:galaxymob/features/cinema/domain/entities/showtime.dart';

/// Repository interface for cinema operations
abstract class CinemaRepository {
  /// Get list of nearby cinemas
  Future<Either<Failure, List<Cinema>>> getNearbyCinemas({
    double? latitude,
    double? longitude,
  });

  /// Get showtimes for a specific movie at all cinemas
  Future<Either<Failure, Map<String, List<Showtime>>>> getShowtimes({
    required int movieId,
    required DateTime date,
  });

  /// Get showtimes for a specific cinema and movie
  Future<Either<Failure, List<Showtime>>> getCinemaShowtimes({
    required String cinemaId,
    required int movieId,
    required DateTime date,
  });
}
