import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/core/widgets/movie_card.dart';
import 'package:galaxymob/core/widgets/section_header.dart';
import 'package:galaxymob/core/widgets/shimmer_loading.dart';
import 'package:galaxymob/core/widgets/state_widgets.dart';
import 'package:galaxymob/features/movies/domain/entities/movie.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_state.dart';

class HomeTrendingSection extends StatelessWidget {
  final MovieSectionState trending;
  final Map<int, String> genreMap;
  final VoidCallback onRetry;
  final void Function(Movie) onTap;
  final VoidCallback? onViewAll;

  const HomeTrendingSection({
    super.key,
    required this.trending,
    required this.genreMap,
    required this.onRetry,
    required this.onTap,
    this.onViewAll,
  });

  bool _isLoading() =>
      (trending.status == LoadStatus.loading ||
          trending.status == LoadStatus.idle) &&
      trending.movies.isEmpty;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Trending Now',
          actionText: 'See All',
          onActionTap: onViewAll,
        ),
        SizedBox(height: AppDimens.spacing12),
        if (_isLoading())
          _buildShimmerList()
        else if (trending.status == LoadStatus.failure &&
            trending.movies.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ErrorStateWidget(
              title: 'Trending unavailable',
              message: trending.error ?? 'Please try again later',
              onRetry: onRetry,
            ),
          )
        else
          SizedBox(
            height: 280,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: AppDimens.spacing16),
              itemCount: trending.movies.length,
              separatorBuilder: (_, __) => SizedBox(width: AppDimens.spacing16),
              itemBuilder: (context, index) {
                final movie = trending.movies[index];
                return MovieCard(
                  title: movie.title,
                  posterPath: movie.fullPosterPath,
                  rating: movie.voteAverage,
                  genre: _getGenreString(movie.genreIds),
                  releaseDate: movie.releaseDate,
                  onTap: () => onTap(movie),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildShimmerList() {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppDimens.spacing16),
        itemCount: 3,
        separatorBuilder: (_, __) => SizedBox(width: AppDimens.spacing12),
        itemBuilder: (_, __) => ShimmerLoading(
          child: ShimmerBox(
            width: AppDimens.movieCardWidth,
            height: double.infinity,
          ),
        ),
      ),
    );
  }

  String _getGenreString(List<int> ids) {
    if (ids.isEmpty || genreMap.isEmpty) return '';
    return ids
        .map((id) => genreMap[id])
        .where((name) => name != null)
        .take(2)
        .join(', ');
  }
}
