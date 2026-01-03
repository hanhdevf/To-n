import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/core/di/injection.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_bloc.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_event.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_state.dart';

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
            if (state is MovieLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: AppColors.error),
                    SizedBox(height: AppDimens.spacing16),
                    Text(state.message, style: AppTextStyles.body1),
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
            } else if (state is MovieDetailLoaded) {
              return _buildMovieDetail(state.movie);
            }

            return const SizedBox.shrink();
          },
        ),
        // Book Ticket button
        bottomNavigationBar: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is! MovieDetailLoaded) return const SizedBox.shrink();

            return Container(
              padding: EdgeInsets.all(AppDimens.spacing16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: () {
                    context.push(
                      '/movie/${widget.movieId}/showtimes',
                      extra: {
                        'movieId': widget.movieId,
                        'movieTitle': state.movie.title,
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    minimumSize: Size(double.infinity, AppDimens.buttonHeight),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusMedium),
                    ),
                  ),
                  child: Text(
                    'Book Ticket',
                    style: AppTextStyles.button,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMovieDetail(movie) {
    return CustomScrollView(
      slivers: [
        // App Bar with backdrop
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: AppColors.background,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            onPressed: () => context.pop(),
          ),
          actions: [
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.share, color: Colors.white),
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.favorite_border, color: Colors.white),
              ),
              onPressed: () {},
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Backdrop image
                if (movie.fullBackdropPath != null)
                  CachedNetworkImage(
                    imageUrl: movie.fullBackdropPath!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: AppColors.surface),
                    errorWidget: (context, url, error) =>
                        Container(color: AppColors.surface),
                  )
                else
                  Container(
                    color: AppColors.surface,
                    child: const Center(child: Icon(Icons.movie, size: 64)),
                  ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.background.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(AppDimens.spacing24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie Title
                Text(
                  movie.title,
                  style: AppTextStyles.h1,
                ),
                SizedBox(height: AppDimens.spacing8),

                // Rating & Info
                Row(
                  children: [
                    const Icon(Icons.star, color: AppColors.warning, size: 20),
                    SizedBox(width: AppDimens.spacing4),
                    Text(
                      movie.voteAverage.toStringAsFixed(1),
                      style: AppTextStyles.body1Medium,
                    ),
                    SizedBox(width: AppDimens.spacing16),
                    Text('•', style: AppTextStyles.body1),
                    SizedBox(width: AppDimens.spacing16),
                    Text(
                      movie.releaseDate,
                      style: AppTextStyles.body2,
                    ),
                  ],
                ),

                SizedBox(height: AppDimens.spacing24),

                // Synopsis
                Text('Synopsis', style: AppTextStyles.h3),
                SizedBox(height: AppDimens.spacing8),
                Text(
                  movie.overview,
                  style: AppTextStyles.body1,
                  maxLines: isExpanded ? null : 3,
                  overflow: isExpanded ? null : TextOverflow.ellipsis,
                ),
                if (movie.overview.length > 100)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: AppDimens.spacing8),
                      child: Text(
                        isExpanded ? 'Read Less' : 'Read More',
                        style: AppTextStyles.body2Medium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),

                SizedBox(height: AppDimens.spacing48),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
