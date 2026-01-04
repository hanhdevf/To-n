import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/movies/domain/entities/cast.dart';
import 'package:galaxymob/features/movies/domain/entities/review.dart';
import 'package:galaxymob/features/movies/domain/usecases/get_movie_credits.dart';
import 'package:galaxymob/features/movies/domain/usecases/get_movie_details.dart';
import 'package:galaxymob/features/movies/domain/usecases/get_movie_reviews.dart';
import 'package:galaxymob/features/movies/domain/usecases/get_now_playing_movies.dart';
import 'package:galaxymob/features/movies/domain/usecases/get_popular_movies.dart';
import 'package:galaxymob/features/movies/domain/usecases/get_trending_movies.dart';
import 'package:galaxymob/features/movies/domain/usecases/get_upcoming_movies.dart';
import 'package:galaxymob/features/movies/domain/usecases/search_movies.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_event.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_state.dart';

/// BLoC for handling movie logic with slice-based loading
class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetUpcomingMovies getUpcomingMovies;
  final GetTrendingMovies getTrendingMovies;
  final GetMovieDetails getMovieDetails;
  final SearchMovies searchMovies;
  final GetMovieCredits getMovieCredits;
  final GetMovieReviews getMovieReviews;

  MovieBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getUpcomingMovies,
    required this.getTrendingMovies,
    required this.getMovieDetails,
    required this.searchMovies,
    required this.getMovieCredits,
    required this.getMovieReviews,
  }) : super(const MovieState()) {
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
    emit(state.copyWith(
      nowPlaying: state.nowPlaying.toLoading(),
    ));

    final result = await getNowPlayingMovies(MovieParams(page: event.page));

    emit(
      result.fold(
        (failure) => state.copyWith(
          nowPlaying: state.nowPlaying.copyWith(
            status: LoadStatus.failure,
            error: failure.message,
          ),
        ),
        (movies) => state.copyWith(
          nowPlaying: state.nowPlaying.copyWith(
            status: LoadStatus.success,
            movies: movies,
            error: null,
          ),
        ),
      ),
    );
  }

  Future<void> _onLoadPopular(
    LoadPopularEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(
      popular: state.popular.toLoading(),
    ));

    final result = await getPopularMovies(MovieParams(page: event.page));

    emit(
      result.fold(
        (failure) => state.copyWith(
          popular: state.popular.copyWith(
            status: LoadStatus.failure,
            error: failure.message,
          ),
        ),
        (movies) => state.copyWith(
          popular: state.popular.copyWith(
            status: LoadStatus.success,
            movies: movies,
            error: null,
          ),
        ),
      ),
    );
  }

  Future<void> _onLoadUpcoming(
    LoadUpcomingEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(
      upcoming: state.upcoming.toLoading(),
    ));

    final result = await getUpcomingMovies(MovieParams(page: event.page));

    emit(
      result.fold(
        (failure) => state.copyWith(
          upcoming: state.upcoming.copyWith(
            status: LoadStatus.failure,
            error: failure.message,
          ),
        ),
        (movies) => state.copyWith(
          upcoming: state.upcoming.copyWith(
            status: LoadStatus.success,
            movies: movies,
            error: null,
          ),
        ),
      ),
    );
  }

  Future<void> _onLoadMovieDetail(
    LoadMovieDetailEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(
      state.copyWith(
        detail: state.detail.copyWith(
          status: LoadStatus.loading,
          error: null,
        ),
      ),
    );

    final result = await getMovieDetails(
      MovieDetailParams(movieId: event.movieId),
    );

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          detail: state.detail.copyWith(
            status: LoadStatus.failure,
            error: failure.message,
          ),
        ),
      ),
      (movie) async {
        // Fetch credits and reviews in parallel
        final results = await Future.wait([
          getMovieCredits(MovieCreditsParams(movieId: event.movieId)),
          getMovieReviews(MovieReviewsParams(movieId: event.movieId)),
        ]);

        final creditsResult = results[0] as Either<Failure, List<Cast>>;
        final reviewsResult = results[1] as Either<Failure, List<Review>>;

        final cast = creditsResult.fold(
          (failure) => <Cast>[],
          (data) => data,
        );

        final reviews = reviewsResult.fold(
          (failure) => <Review>[],
          (data) => data,
        );

        emit(
          state.copyWith(
            detail: state.detail.copyWith(
              status: LoadStatus.success,
              movie: movie,
              cast: cast,
              reviews: reviews,
              error: null,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onSearchMovies(
    SearchMoviesEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(
      state.copyWith(
        search: state.search.copyWith(
          status: LoadStatus.loading,
          query: event.query,
          error: null,
        ),
      ),
    );

    final result = await searchMovies(
      SearchParams(
        query: event.query,
        page: event.page,
        genreId: event.genreId,
        year: event.year,
        sortBy: event.sortBy,
      ),
    );

    emit(
      result.fold(
        (failure) => state.copyWith(
          search: state.search.copyWith(
            status: LoadStatus.failure,
            error: failure.message,
          ),
        ),
        (movies) => state.copyWith(
          search: state.search.copyWith(
            status: LoadStatus.success,
            results: movies,
            error: null,
          ),
        ),
      ),
    );
  }

  Future<void> _onLoadTrending(
    LoadTrendingEvent event,
    Emitter<MovieState> emit,
  ) async {
    emit(state.copyWith(
      trending: state.trending.toLoading(),
    ));

    final result = await getTrendingMovies(MovieParams(page: event.page));

    emit(
      result.fold(
        (failure) => state.copyWith(
          trending: state.trending.copyWith(
            status: LoadStatus.failure,
            error: failure.message,
          ),
        ),
        (movies) => state.copyWith(
          trending: state.trending.copyWith(
            status: LoadStatus.success,
            movies: movies,
            error: null,
          ),
        ),
      ),
    );
  }
}
