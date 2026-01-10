import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/core/di/injection.dart';
import 'package:galaxymob/config/routes/route_args.dart';
import 'package:galaxymob/features/cinema/presentation/bloc/cinema_bloc.dart';
import 'package:galaxymob/features/cinema/presentation/bloc/cinema_event.dart';
import 'package:galaxymob/features/cinema/presentation/pages/schedule_view_page.dart';
import 'package:galaxymob/features/cinema/presentation/pages/showtime_selection_page.dart';
import 'package:galaxymob/features/movies/presentation/bloc/genre_bloc.dart';
import 'package:galaxymob/features/movies/presentation/bloc/genre_event.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_bloc.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_event.dart';
import 'package:galaxymob/features/movies/presentation/pages/all_reviews_page.dart';
import 'package:galaxymob/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:galaxymob/features/movies/presentation/pages/movie_list_page.dart';

/// Movie and cinema-related routes.
final List<GoRoute> movieRoutes = [
  GoRoute(
    path: '/movie/:id',
    name: 'movieDetail',
    builder: (context, state) {
      final movieId = int.parse(state.pathParameters['id']!);
      return MovieDetailPage(movieId: movieId);
    },
  ),
  GoRoute(
    path: '/movies/:category',
    name: 'movieList',
    builder: (context, state) {
      final category = state.pathParameters['category']!;
      final title = state.uri.queryParameters['title'] ?? 'Movies';
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt<MovieBloc>()
              ..add(category == 'trending'
                  ? const LoadTrendingEvent()
                  : const LoadUpcomingEvent()),
          ),
          BlocProvider(
            create: (context) => getIt<GenreBloc>()..add(const LoadGenresEvent()),
          ),
        ],
        child: MovieListPage(
          category: category,
          title: title,
        ),
      );
    },
  ),
  GoRoute(
    path: '/schedule',
    name: 'schedule',
    builder: (context, state) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                getIt<CinemaBloc>()..add(LoadScheduleEvent(date: DateTime.now())),
          ),
          BlocProvider(
            create: (context) => getIt<MovieBloc>()..add(const LoadNowPlayingEvent()),
          ),
          BlocProvider(
            create: (context) => getIt<GenreBloc>()..add(const LoadGenresEvent()),
          ),
        ],
        child: const ScheduleViewPage(),
      );
    },
  ),
  GoRoute(
    path: '/movie/:id/showtimes',
    name: 'showtimeSelection',
    builder: (context, state) {
      final extra = state.extra as MovieShowtimeArgs?;
      final movieIdParam = int.parse(state.pathParameters['id']!);
      return BlocProvider(
        create: (context) => getIt<CinemaBloc>(),
        child: ShowtimeSelectionPage(
          movieId: extra?.movieId ?? movieIdParam,
          movieTitle: extra?.movieTitle ?? '',
        ),
      );
    },
  ),
  GoRoute(
    path: '/all-reviews',
    name: 'all_reviews',
    builder: (context, state) {
      final extras = state.extra as AllReviewsArgs?;
      if (extras == null) {
        return const SizedBox.shrink(); // or another safe fallback
      }
      return AllReviewsPage(
        reviews: extras.reviews,
        movieTitle: extras.movieTitle,
      );
    },
  ),
];
