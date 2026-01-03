import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/movies/domain/entities/movie.dart';
import 'package:galaxymob/features/movies/domain/repositories/movie_repository.dart';
import 'package:galaxymob/features/movies/domain/usecases/get_now_playing_movies.dart';

class GetTrendingMovies implements UseCase<List<Movie>, MovieParams> {
  final MovieRepository repository;

  GetTrendingMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(MovieParams params) async {
    return await repository.getTrending(page: params.page);
  }
}
