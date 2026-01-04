import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/core/widgets/shimmer_loading.dart';
import 'package:galaxymob/core/widgets/state_widgets.dart';
import 'package:galaxymob/features/home/presentation/widgets/grid_movie_card.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_state.dart';

class HomeComingSoonSection extends StatelessWidget {
  final MovieSectionState upcoming;
  final VoidCallback onRetry;
  final void Function(int movieId) onTap;

  const HomeComingSoonSection({
    super.key,
    required this.upcoming,
    required this.onRetry,
    required this.onTap,
  });

  bool _isLoading() =>
      (upcoming.status == LoadStatus.loading ||
          upcoming.status == LoadStatus.idle) &&
      upcoming.movies.isEmpty;

  @override
  Widget build(BuildContext context) {
    if (_isLoading()) {
      return SliverToBoxAdapter(
        child: _buildShimmerSection(height: 200, count: 2),
      );
    }

    if (upcoming.status == LoadStatus.failure && upcoming.movies.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ErrorStateWidget(
            title: 'Coming soon unavailable',
            message: upcoming.error ?? 'Please try again later',
            onRetry: onRetry,
          ),
        ),
      );
    }

    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: AppDimens.spacing16,
        mainAxisSpacing: AppDimens.spacing16,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final movie = upcoming.movies[index];
          return GridMovieCard(
            movie: movie,
            onTap: () => onTap(movie.id),
          );
        },
        childCount: upcoming.movies.take(4).length,
      ),
    );
  }

  Widget _buildShimmerSection({double height = 200, int count = 1}) {
    return Column(
      children: List.generate(
        count,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.spacing16),
          child: ShimmerLoading(
            child: ShimmerBox(
              width: double.infinity,
              height: height,
            ),
          ),
        ),
      ),
    );
  }
}
