import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxymob/features/movies/domain/usecases/get_movie_details.dart';
import 'package:galaxymob/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:galaxymob/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:galaxymob/features/movies/domain/usecases/get_upcoming_movies.dart';
import 'package:galaxymob/features/movies/domain/usecases/get_trending_movies.dart';
import 'package:galaxymob/features/movies/domain/usecases/search_movies.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_event.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_state.dart';

/// BLoC for handling movie logic
class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetUpcomingMovies getUpcomingMovies;
  final GetTrendingMovies getTrendingMovies;
  final GetMovieDetails getMovieDetails;
  final SearchMovies searchMovies;

  MovieBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getUpcomingMovies,
    required this.getTrendingMovies,
    required this.getMovieDetails,
    required this.searchMovies,
  }) : super(const MovieInitial()) {
    on<LoadNowPlayingEvent>(_onLoadNowPlaying);
    on<LoadPopularEvent>(_onLoadPopular);
    on<LoadUpcomingEvent>(_onLoadUpcoming);
    on<LoadTrendingEvent>(_onLoadTrending);
    on<LoadMovieDetailEvent>(_onLoadMovieDetail);
    on<SearchMoviesEvent>(_onSearchMovies);
  }

  Future<void> _onLoadNowPlaying(
    LoadNowPlayingEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(const MovieLoading());

    final result = await getNowPlayingMovies(MovieParams(page: event.page));

    result.fold(
      (failure) => emit(MovieError(failure.message)),
      (movies) => emit(NowPlayingLoaded(movies)),
    );
  }

  Future<void> _onLoadPopular(
    LoadPopularEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(const MovieLoading());

    final result = await getPopularMovies(MovieParams(page: event.page));

    result.fold(
      (failure) => emit(MovieError(failure.message)),
      (movies) => emit(PopularLoaded(movies)),
    );
  }

  Future<void> _onLoadUpcoming(
    LoadUpcomingEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(const MovieLoading());

    final result = await getUpcomingMovies(MovieParams(page: event.page));

    result.fold(
      (failure) => emit(MovieError(failure.message)),
      (movies) => emit(UpcomingLoaded(movies)),
    );
  }

  Future<void> _onLoadMovieDetail(
    LoadMovieDetailEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(const MovieLoading());

    final result = await getMovieDetails(
      MovieDetailParams(movieId: event.movieId),
    );

    result.fold(
      (failure) => emit(MovieError(failure.message)),
      (movie) => emit(MovieDetailLoaded(movie)),
    );
  }

  Future<void> _onSearchMovies(
    SearchMoviesEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(const MovieLoading());

    final result = await searchMovies(
      SearchParams(query: event.query, page: event.page),
    );

    result.fold(
      (failure) => emit(MovieError(failure.message)),
      (movies) => emit(SearchResultsLoaded(movies, event.query)),
    );
  }

  Future<void> _onLoadTrending(
    LoadTrendingEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(const MovieLoading());

    final result = await getTrendingMovies(MovieParams(page: event.page));

    result.fold(
      (failure) => emit(MovieError(failure.message)),
      (movies) => emit(TrendingLoaded(movies)),
    );
  }
}
