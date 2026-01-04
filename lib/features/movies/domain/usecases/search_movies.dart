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
    // 1. If query is empty but filters exist, use DISCOVER (Server-side filtering)
    if (params.query.isEmpty &&
        (params.genreId != null ||
            params.year != null ||
            params.sortBy != null)) {
      return await repository.discoverMovies(
        page: params.page,
        withGenres: params.genreId?.toString(),
        year: params.year,
        sortBy: params.sortBy,
      );
    }

    // 2. If query is present, use SEARCH
    if (params.query.isNotEmpty) {
      final result = await repository.searchMovies(
        query: params.query,
        page: params.page,
      );

      // Apply client-side filtering if filters are present
      // Note: This only filters the current page of results
      if (params.genreId != null || params.year != null) {
        return result.map((movies) {
          var filtered = movies;

          if (params.genreId != null) {
            filtered = filtered
                .where((m) => m.genreIds.contains(params.genreId))
                .toList();
          }

          if (params.year != null) {
            filtered = filtered
                .where((m) =>
                    DateTime.tryParse(m.releaseDate)?.year == params.year)
                .toList();
          }

          return filtered;
        });
      }

      return result;
    }

    // 3. Fallback (empty query and no filters) -> Return empty or maybe Trending?
    // Let's return empty list for now
    return const Right([]);
  }
}

/// Parameters for search use case
class SearchParams extends Equatable {
  final String query;
  final int page;
  final int? genreId;
  final int? year;
  final String? sortBy; // e.g., 'popularity.desc'

  const SearchParams({
    required this.query,
    this.page = 1,
    this.genreId,
    this.year,
    this.sortBy,
  });

  @override
  List<Object?> get props => [query, page, genreId, year, sortBy];
}
