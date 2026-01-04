import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/core/widgets/shimmer_loading.dart';
import 'package:galaxymob/core/widgets/state_widgets.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_bloc.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_event.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_state.dart';
import 'package:galaxymob/features/home/presentation/widgets/movie_list_grid.dart';
import 'package:go_router/go_router.dart';

/// Page that displays a full list of movies for a specific category
class MovieListPage extends StatelessWidget {
  final String category;
  final String title;

  const MovieListPage({
    super.key,
    required this.category,
    required this.title,
  });

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
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          final sectionState = _getSectionState(state);

          if (_isLoading(sectionState)) {
            return _buildShimmerGrid();
          }

          if (sectionState.status == LoadStatus.failure &&
              sectionState.movies.isEmpty) {
            return Center(
              child: ErrorStateWidget(
                title: 'Failed to load movies',
                message: sectionState.error ?? 'Please try again later',
                onRetry: () => _retryLoad(context),
              ),
            );
          }

          if (sectionState.movies.isEmpty) {
            return const Center(
              child: EmptyStateWidget(
                icon: Icons.movie_outlined,
                title: 'No Movies',
                message: 'No movies available at the moment',
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => _retryLoad(context),
            child: MovieListGrid(movies: sectionState.movies),
          );
        },
      ),
    );
  }

  MovieSectionState _getSectionState(MovieState state) {
    switch (category) {
      case 'trending':
        return state.trending;
      case 'upcoming':
        return state.upcoming;
      default:
        return state.trending;
    }
  }

  bool _isLoading(MovieSectionState sectionState) =>
      (sectionState.status == LoadStatus.loading ||
          sectionState.status == LoadStatus.idle) &&
      sectionState.movies.isEmpty;

  void _retryLoad(BuildContext context) {
    final bloc = context.read<MovieBloc>();
    if (category == 'trending') {
      bloc.add(const LoadTrendingEvent());
    } else if (category == 'upcoming') {
      bloc.add(const LoadUpcomingEvent());
    }
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: EdgeInsets.all(AppDimens.spacing16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: AppDimens.spacing16,
        mainAxisSpacing: AppDimens.spacing16,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => ShimmerLoading(
        child: ShimmerBox(
          width: double.infinity,
          height: double.infinity,
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        ),
      ),
    );
  }
}
