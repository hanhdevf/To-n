import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/movies/domain/entities/movie.dart';
import 'package:galaxymob/features/movies/domain/repositories/movie_repository.dart';

/// Use case for searching movies
class SearchMovies implements UseCase<List<Movie>, SearchParams> {
  final MovieRepository repository;

  SearchMovies(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(SearchParams params) async {
    return await repository.searchMovies(
      query: params.query,
      page: params.page,
    );
  }
}

/// Parameters for search use case
class SearchParams extends Equatable {
  final String query;
  final int page;

  const SearchParams({
    required this.query,
    this.page = 1,
  });

  @override
  List<Object?> get props => [query, page];
}
