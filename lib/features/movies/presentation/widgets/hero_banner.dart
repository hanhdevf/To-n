import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/movies/domain/entities/movie.dart';

/// Hero banner with auto-carousel for featured movies
class HeroBanner extends StatefulWidget {
  final List<Movie> movies;
  final Function(Movie)? onMovieTap;

  const HeroBanner({
    super.key,
    required this.movies,
    this.onMovieTap,
  });

  @override
  State<HeroBanner> createState() => _HeroBannerState();
}

class _HeroBannerState extends State<HeroBanner> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: widget.movies.length > 5 ? 5 : widget.movies.length,
          options: CarouselOptions(
            height: 400,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.easeInOutCubic,
            enlargeCenterPage: false,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final movie = widget.movies[index];
            return _buildBannerItem(movie);
          },
        ),

        // Page indicators
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              widget.movies.length > 5 ? 5 : widget.movies.length,
              (index) => Container(
                width: _currentIndex == index ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _currentIndex == index
                      ? AppColors.primary
                      : AppColors.white.withValues(alpha: 0.3),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerItem(Movie movie) {
    return GestureDetector(
      onTap: () => widget.onMovieTap?.call(movie),
      child: Stack(
        children: [
          // Backdrop image
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: movie.fullBackdropPath ?? '',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: AppColors.surface,
              ),
              errorWidget: (context, url, error) => Container(
                color: AppColors.surface,
                child: const Icon(Icons.error),
              ),
            ),
          ),

          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                    Colors.black.withValues(alpha: 0.9),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),

          // Content
          Positioned(
            left: AppDimens.spacing24,
            right: AppDimens.spacing24,
            bottom: AppDimens.spacing48,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  movie.title,
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 28,
                    color: AppColors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.8),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppDimens.spacing8),

                // Rating
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: AppColors.warning,
                      size: 20,
                    ),
                    SizedBox(width: AppDimens.spacing4),
                    Text(
                      movie.voteAverage.toStringAsFixed(1),
                      style: AppTextStyles.body1Medium.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                    SizedBox(width: AppDimens.spacing8),
                    Text(
                      '•',
                      style: TextStyle(color: AppColors.white),
                    ),
                    SizedBox(width: AppDimens.spacing8),
                    Text(
                      movie.releaseDate,
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
