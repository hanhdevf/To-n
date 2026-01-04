import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/core/di/injection.dart';
import 'package:galaxymob/features/movies/domain/entities/cast.dart';
import 'package:galaxymob/features/movies/domain/entities/movie.dart';
import 'package:galaxymob/features/movies/domain/entities/review.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_bloc.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_event.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_state.dart';
import 'package:galaxymob/features/movies/presentation/widgets/cast_list.dart';
import 'package:galaxymob/features/movies/presentation/widgets/detail/movie_detail_app_bar.dart';
import 'package:galaxymob/features/movies/presentation/widgets/detail/movie_detail_bottom_bar.dart';
import 'package:galaxymob/features/movies/presentation/widgets/detail/movie_detail_synopsis.dart';
import 'package:galaxymob/features/movies/presentation/widgets/review_list.dart';

/// Movie detail page showing full information
class MovieDetailPage extends StatefulWidget {
  final int movieId;

  const MovieDetailPage({
    super.key,
    required this.movieId,
  });

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<MovieBloc>()..add(LoadMovieDetailEvent(widget.movieId)),
      child: Scaffold(
        body: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            final detail = state.detail;

            if (detail.status == LoadStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (detail.status == LoadStatus.failure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: AppColors.error),
                    SizedBox(height: AppDimens.spacing16),
                    Text(detail.error ?? 'Unable to load movie',
                        style: AppTextStyles.body1),
                    SizedBox(height: AppDimens.spacing24),
                    ElevatedButton(
                      onPressed: () {
                        context
                            .read<MovieBloc>()
                            .add(LoadMovieDetailEvent(widget.movieId));
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (detail.status == LoadStatus.success && detail.movie != null) {
              return _buildMovieDetail(
                detail.movie!,
                detail.cast,
                detail.reviews,
              );
            }

            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state.detail.status != LoadStatus.success ||
                state.detail.movie == null) {
              return const SizedBox.shrink();
            }

            final movie = state.detail.movie!;

            return MovieDetailBottomBar(
              onBook: () {
                context.push(
                  '/movie/${widget.movieId}/showtimes',
                  extra: {
                    'movieId': widget.movieId,
                    'movieTitle': movie.title,
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildMovieDetail(
    Movie movie,
    List<Cast> cast,
    List<Review> reviews,
  ) {
    return CustomScrollView(
      slivers: [
        MovieDetailAppBar(
          movie: movie,
          onBack: () => context.pop(),
          onPlay: () {},
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppDimens.spacing24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MovieDetailSynopsis(
                  overview: movie.overview,
                  isExpanded: isExpanded,
                  onToggle: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                ),
                SizedBox(height: AppDimens.spacing24),
                if (cast.isNotEmpty) ...[
                  CastList(cast: cast),
                  SizedBox(height: AppDimens.spacing24),
                ],
                if (reviews.isNotEmpty) ...[
                  ReviewList(
                    reviews: reviews,
                    movieTitle: movie.title,
                  ),
                  SizedBox(height: AppDimens.spacing24),
                ],
                SizedBox(height: AppDimens.spacing24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
