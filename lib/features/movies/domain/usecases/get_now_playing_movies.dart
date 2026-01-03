import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/movies/domain/entities/movie.dart';
import 'package:galaxymob/features/movies/domain/repositories/movie_repository.dart';

/// Use case for getting now playing movies
class GetNowPlayingMovies implements UseCase<List<Movie>, MovieParams> {
  final MovieRepository repository;

  GetNowPlayingMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(MovieParams params) async {
    return await repository.getNowPlaying(page: params.page);
  }
}

/// Parameters for movie use cases
class MovieParams extends Equatable {
  final int page;

  const MovieParams({this.page = 1});

  @override
  List<Object?> get props => [page];
}
