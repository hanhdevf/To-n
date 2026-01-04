import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/core/widgets/section_header.dart';
import 'package:galaxymob/core/widgets/shimmer_loading.dart';
import 'package:galaxymob/core/widgets/state_widgets.dart';
import 'package:galaxymob/features/home/presentation/widgets/featured_movie_card.dart';
import 'package:galaxymob/features/movies/domain/entities/movie.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_state.dart';

class HomeFeaturedSection extends StatelessWidget {
  final MovieSectionState popular;
  final Map<int, String> genreMap;
  final VoidCallback onRetry;
  final void Function(Movie) onTap;

  const HomeFeaturedSection({
    super.key,
    required this.popular,
    required this.genreMap,
    required this.onRetry,
    required this.onTap,
  });

  bool _isLoading() =>
      (popular.status == LoadStatus.loading ||
          popular.status == LoadStatus.idle) &&
      popular.movies.isEmpty;

  @override
  Widget build(BuildContext context) {
    if (_isLoading()) {
      return _buildShimmerSection(height: 220);
    }

    if (popular.status == LoadStatus.failure && popular.movies.isEmpty) {
      return ErrorStateWidget(
        title: 'Spotlight unavailable',
        message: popular.error ?? 'Could not load popular movies',
        onRetry: onRetry,
      );
    }

    if (popular.movies.isEmpty) return const SizedBox.shrink();

    final featuredMovie = popular.movies.first;
    final genres = _getGenreString(featuredMovie.genreIds);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Spotlight'),
          SizedBox(height: AppDimens.spacing12),
          featuredMovie.backdropPath != null
              ? FeaturedMovieCard(
                  movie: featuredMovie,
                  genresLabel: genres,
                  onTap: () => onTap(featuredMovie),
                  onBookTap: () => onTap(featuredMovie),
                )
              : const SizedBox.shrink(),
        ],
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

  String _getGenreString(List<int> ids) {
    if (ids.isEmpty || genreMap.isEmpty) return '';
    return ids
        .map((id) => genreMap[id])
        .where((name) => name != null)
        .take(2)
        .join(', ');
  }
}
