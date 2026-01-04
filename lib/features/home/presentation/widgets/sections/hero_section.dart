import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/core/widgets/shimmer_loading.dart';
import 'package:galaxymob/core/widgets/state_widgets.dart';
import 'package:galaxymob/features/movies/domain/entities/movie.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_state.dart';
import 'package:galaxymob/features/movies/presentation/widgets/hero_banner.dart';

class HomeHeroSection extends StatelessWidget {
  final MovieSectionState trending;
  final VoidCallback onRetry;
  final void Function(Movie) onMovieTap;

  const HomeHeroSection({
    super.key,
    required this.trending,
    required this.onRetry,
    required this.onMovieTap,
  });

  bool _isLoading() =>
      (trending.status == LoadStatus.loading ||
          trending.status == LoadStatus.idle) &&
      trending.movies.isEmpty;

  @override
  Widget build(BuildContext context) {
    if (_isLoading()) {
      return ShimmerLoading(
        child: ShimmerBox(
          width: double.infinity,
          height: AppDimens.heroBannerHeight + 50,
        ),
      );
    }

    if (trending.status == LoadStatus.failure && trending.movies.isEmpty) {
      return ErrorStateWidget(
        title: 'Trending unavailable',
        message: trending.error ?? 'Something went wrong',
        onRetry: onRetry,
      );
    }

    final heroMovies = trending.movies.take(5).toList();
    if (heroMovies.isEmpty) return const SizedBox.shrink();

    return HeroBanner(
      movies: heroMovies,
      onMovieTap: onMovieTap,
    );
  }
}
