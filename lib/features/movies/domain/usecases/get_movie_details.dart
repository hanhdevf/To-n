import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/movies/domain/entities/movie.dart';
import 'package:galaxymob/features/movies/domain/repositories/movie_repository.dart';

/// Use case for getting movie details by ID
class GetMovieDetails implements UseCase<Movie, MovieDetailParams> {
  final MovieRepository repository;

  GetMovieDetails(this.repository);

  @override
  Future<Either<Failure, Movie>> call(MovieDetailParams params) async {
    return await repository.getMovieDetails(params.movieId);
  }
}

/// Parameters for movie detail use case
class MovieDetailParams extends Equatable {
  final int movieId;

  const MovieDetailParams({required this.movieId});

  @override
  List<Object?> get props => [movieId];
}
