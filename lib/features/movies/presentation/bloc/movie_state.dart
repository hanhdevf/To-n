import 'package:equatable/equatable.dart';
import 'package:galaxymob/features/movies/domain/entities/movie.dart';

/// Movie States
abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class MovieInitial extends MovieState {
  const MovieInitial();
}

/// Loading state
class MovieLoading extends MovieState {
  const MovieLoading();
}

/// Now playing movies loaded
class NowPlayingLoaded extends MovieState {
  final List<Movie> movies;

  const NowPlayingLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

/// Popular movies loaded
class PopularLoaded extends MovieState {
  final List<Movie> movies;

  const PopularLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

/// Upcoming movies loaded
class UpcomingLoaded extends MovieState {
  final List<Movie> movies;

  const UpcomingLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

/// Trending movies loaded
class TrendingLoaded extends MovieState {
  final List<Movie> movies;

  const TrendingLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

/// Search results loaded
class SearchResultsLoaded extends MovieState {
  final List<Movie> movies;
  final String query;

  const SearchResultsLoaded(this.movies, this.query);

  @override
  List<Object?> get props => [movies, query];
}

/// Movie detail loaded
class MovieDetailLoaded extends MovieState {
  final Movie movie;

  const MovieDetailLoaded(this.movie);

  @override
  List<Object?> get props => [movie];
}

/// Error state
class MovieError extends MovieState {
  final String message;

  const MovieError(this.message);

  @override
  List<Object?> get props => [message];
}
