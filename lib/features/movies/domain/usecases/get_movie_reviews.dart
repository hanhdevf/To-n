import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/movies/domain/entities/review.dart';
import 'package:galaxymob/features/movies/domain/repositories/movie_repository.dart';

class GetMovieReviews implements UseCase<List<Review>, MovieReviewsParams> {
  final MovieRepository repository;

  GetMovieReviews(this.repository);

  @override
  Future<Either<Failure, List<Review>>> call(MovieReviewsParams params) async {
    return await repository.getMovieReviews(params.movieId);
  }
}

class MovieReviewsParams extends Equatable {
  final int movieId;

  const MovieReviewsParams({required this.movieId});

  @override
  List<Object?> get props => [movieId];
}
