import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/movies/domain/entities/cast.dart';
import 'package:galaxymob/features/movies/domain/repositories/movie_repository.dart';

class GetMovieCredits implements UseCase<List<Cast>, MovieCreditsParams> {
  final MovieRepository repository;

  GetMovieCredits(this.repository);

  @override
  Future<Either<Failure, List<Cast>>> call(MovieCreditsParams params) async {
    return await repository.getMovieCredits(params.movieId);
  }
}

class MovieCreditsParams extends Equatable {
  final int movieId;

  const MovieCreditsParams({required this.movieId});

  @override
  List<Object?> get props => [movieId];
}
