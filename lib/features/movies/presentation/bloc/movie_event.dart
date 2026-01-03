import 'package:equatable/equatable.dart';

/// Movie Events
abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => [];
}

/// Load now playing movies
class LoadNowPlayingEvent extends MovieEvent {
  final int page;

  const LoadNowPlayingEvent({this.page = 1});

  @override
  List<Object?> get props => [page];
}

/// Load popular movies
class LoadPopularEvent extends MovieEvent {
  final int page;

  const LoadPopularEvent({this.page = 1});

  @override
  List<Object?> get props => [page];
}

/// Load upcoming movies
class LoadUpcomingEvent extends MovieEvent {
  final int page;

  const LoadUpcomingEvent({this.page = 1});

  @override
  List<Object?> get props => [page];
}

/// Search movies
class SearchMoviesEvent extends MovieEvent {
  final String query;
  final int page;

  const SearchMoviesEvent({
    required this.query,
    this.page = 1,
  });

  @override
  List<Object?> get props => [query, page];
}

/// Load trending movies
class LoadTrendingEvent extends MovieEvent {
  final int page;

  const LoadTrendingEvent({this.page = 1});

  @override
  List<Object?> get props => [page];
}

/// Load movie details by ID
class LoadMovieDetailEvent extends MovieEvent {
  final int movieId;

  const LoadMovieDetailEvent(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
