import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/movies/domain/entities/movie.dart';

/// Repository interface for movie operations
abstract class MovieRepository {
  /// Get list of now playing movies
  Future<Either<Failure, List<Movie>>> getNowPlaying({int page = 1});

  /// Get list of popular movies
  Future<Either<Failure, List<Movie>>> getPopular({int page = 1});

  /// Get list of upcoming movies
  Future<Either<Failure, List<Movie>>> getUpcoming({int page = 1});

  /// Get list of top rated movies
  Future<Either<Failure, List<Movie>>> getTopRated({int page = 1});

  /// Get list of trending movies
  Future<Either<Failure, List<Movie>>> getTrending({int page = 1});

  /// Get movie details by ID
  Future<Either<Failure, Movie>> getMovieDetails(int movieId);

  /// Search movies by query
  Future<Either<Failure, List<Movie>>> searchMovies({
    required String query,
    int page = 1,
  });
}
