import 'package:equatable/equatable.dart';
import 'package:galaxymob/features/movies/domain/entities/cast.dart';
import 'package:galaxymob/features/movies/domain/entities/movie.dart';
import 'package:galaxymob/features/movies/domain/entities/review.dart';

enum LoadStatus { idle, loading, success, failure }

class MovieSectionState extends Equatable {
  final LoadStatus status;
  final List<Movie> movies;
  final String? error;

  const MovieSectionState({
    this.status = LoadStatus.idle,
    this.movies = const [],
    this.error,
  });

  MovieSectionState copyWith({
    LoadStatus? status,
    List<Movie>? movies,
    String? error,
  }) {
    return MovieSectionState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      error: error,
    );
  }

  MovieSectionState toLoading() =>
      copyWith(status: LoadStatus.loading, error: null);

  @override
  List<Object?> get props => [status, movies, error];
}

class MovieSearchState extends Equatable {
  final LoadStatus status;
  final String query;
  final List<Movie> results;
  final String? error;

  const MovieSearchState({
    this.status = LoadStatus.idle,
    this.query = '',
    this.results = const [],
    this.error,
  });

  MovieSearchState copyWith({
    LoadStatus? status,
    String? query,
    List<Movie>? results,
    String? error,
  }) {
    return MovieSearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      results: results ?? this.results,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, query, results, error];
}

class MovieDetailState extends Equatable {
  final LoadStatus status;
  final Movie? movie;
  final List<Cast> cast;
  final List<Review> reviews;
  final String? error;

  const MovieDetailState({
    this.status = LoadStatus.idle,
    this.movie,
    this.cast = const [],
    this.reviews = const [],
    this.error,
  });

  MovieDetailState copyWith({
    LoadStatus? status,
    Movie? movie,
    List<Cast>? cast,
    List<Review>? reviews,
    String? error,
  }) {
    return MovieDetailState(
      status: status ?? this.status,
      movie: movie ?? this.movie,
      cast: cast ?? this.cast,
      reviews: reviews ?? this.reviews,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, movie, cast, reviews, error];
}

class MovieState extends Equatable {
  final MovieSectionState nowPlaying;
  final MovieSectionState popular;
  final MovieSectionState upcoming;
  final MovieSectionState trending;
  final MovieSearchState search;
  final MovieDetailState detail;

  const MovieState({
    this.nowPlaying = const MovieSectionState(),
    this.popular = const MovieSectionState(),
    this.upcoming = const MovieSectionState(),
    this.trending = const MovieSectionState(),
    this.search = const MovieSearchState(),
    this.detail = const MovieDetailState(),
  });

  MovieState copyWith({
    MovieSectionState? nowPlaying,
    MovieSectionState? popular,
    MovieSectionState? upcoming,
    MovieSectionState? trending,
    MovieSearchState? search,
    MovieDetailState? detail,
  }) {
    return MovieState(
      nowPlaying: nowPlaying ?? this.nowPlaying,
      popular: popular ?? this.popular,
      upcoming: upcoming ?? this.upcoming,
      trending: trending ?? this.trending,
      search: search ?? this.search,
      detail: detail ?? this.detail,
    );
  }

  @override
  List<Object?> get props => [
        nowPlaying,
        popular,
        upcoming,
        trending,
        search,
        detail,
      ];
}
