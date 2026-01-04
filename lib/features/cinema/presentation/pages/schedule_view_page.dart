import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/core/widgets/state_widgets.dart';
import 'package:galaxymob/core/widgets/shimmer_loading.dart';
import 'package:galaxymob/features/cinema/presentation/bloc/cinema_bloc.dart';
import 'package:galaxymob/features/cinema/presentation/bloc/cinema_event.dart';
import 'package:galaxymob/features/cinema/presentation/bloc/cinema_state.dart';
import 'package:galaxymob/features/cinema/domain/entities/showtime.dart';
import 'package:galaxymob/features/cinema/presentation/widgets/schedule_date_picker.dart';
import 'package:galaxymob/features/cinema/presentation/widgets/schedule_movie_card.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_bloc.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_event.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_state.dart';
import 'package:galaxymob/features/movies/presentation/bloc/genre_bloc.dart';
import 'package:galaxymob/features/movies/presentation/bloc/genre_state.dart';

/// Schedule view page showing all movies with their showtimes
class ScheduleViewPage extends StatefulWidget {
  const ScheduleViewPage({super.key});

  @override
  State<ScheduleViewPage> createState() => _ScheduleViewPageState();
}

class _ScheduleViewPageState extends State<ScheduleViewPage> {
  DateTime selectedDate = DateTime.now();
  final List<DateTime> availableDates = [];

  @override
  void initState() {
    super.initState();
    _generateDates();
    _loadSchedule();
  }

  void _generateDates() {
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      availableDates.add(now.add(Duration(days: i)));
    }
  }

  void _loadSchedule() {
    // Load now playing movies to display in schedule
    context.read<MovieBloc>().add(const LoadNowPlayingEvent());
    // Load schedule data (currently returns empty, needs backend support)
    context.read<CinemaBloc>().add(LoadScheduleEvent(date: selectedDate));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Movie Schedule',
          style: AppTextStyles.h3.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Date Picker
          ScheduleDatePicker(
            availableDates: availableDates,
            selectedDate: selectedDate,
            onDateSelected: (date) {
              setState(() {
                selectedDate = date;
              });
              _loadSchedule();
            },
          ),

          // Schedule List
          Expanded(
            child: BlocBuilder<MovieBloc, MovieState>(
              builder: (context, movieState) {
                return BlocBuilder<GenreBloc, GenreState>(
                  builder: (context, genreState) {
                    final genreMap = genreState is GenreLoaded
                        ? {for (var g in genreState.genres) g.id: g.name}
                        : const <int, String>{};

                    return BlocBuilder<CinemaBloc, CinemaState>(
                      builder: (context, cinemaState) {
                        if (_isLoading(movieState, cinemaState)) {
                          return _buildShimmerList();
                        }

                        if (movieState.nowPlaying.status ==
                            LoadStatus.failure) {
                          return ErrorStateWidget(
                            title: 'Failed to load schedule',
                            message: movieState.nowPlaying.error ??
                                'Please try again later',
                            onRetry: _loadSchedule,
                          );
                        }

                        final movies = movieState.nowPlaying.movies;
                        if (movies.isEmpty) {
                          return const EmptyStateWidget(
                            icon: Icons.calendar_today,
                            title: 'No Schedule',
                            message: 'No movies scheduled for this date',
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: () async => _loadSchedule(),
                          child: ListView.separated(
                            padding: EdgeInsets.all(AppDimens.spacing16),
                            itemCount: movies.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: AppDimens.spacing16),
                            itemBuilder: (context, index) {
                              final movie = movies[index];
                              final genreText = _getGenreString(
                                movie.genreIds,
                                genreMap,
                              );

                              // Get showtimes for this movie from cinema state
                              final showtimes = cinemaState is ScheduleLoaded
                                  ? (cinemaState.showtimesByMovie[movie.id]
                                          ?.cast<Showtime>() ??
                                      <Showtime>[])
                                  : <Showtime>[];

                              return ScheduleMovieCard(
                                movie: movie,
                                showtimes: showtimes,
                                genreText: genreText,
                                onMovieTap: () =>
                                    context.push('/movie/${movie.id}'),
                              );
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _isLoading(MovieState movieState, CinemaState cinemaState) {
    final movieLoading = (movieState.nowPlaying.status == LoadStatus.loading ||
            movieState.nowPlaying.status == LoadStatus.idle) &&
        movieState.nowPlaying.movies.isEmpty;

    final cinemaLoading = cinemaState is CinemaLoading;

    return movieLoading || cinemaLoading;
  }

  String _getGenreString(List<int> ids, Map<int, String> genreMap) {
    if (ids.isEmpty || genreMap.isEmpty) return '';
    return ids
        .map((id) => genreMap[id])
        .where((name) => name != null)
        .take(2)
        .join(', ');
  }

  Widget _buildShimmerList() {
    return ListView.separated(
      padding: EdgeInsets.all(AppDimens.spacing16),
      itemCount: 5,
      separatorBuilder: (context, index) =>
          SizedBox(height: AppDimens.spacing16),
      itemBuilder: (context, index) => ShimmerLoading(
        child: ShimmerBox(
          width: double.infinity,
          height: 144, // Same as ScheduleMovieCard height
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        ),
      ),
    );
  }
}
