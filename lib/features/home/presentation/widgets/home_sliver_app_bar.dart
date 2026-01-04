import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/core/widgets/shimmer_loading.dart';
import 'package:galaxymob/core/widgets/state_widgets.dart';
import 'package:galaxymob/features/movies/domain/entities/movie.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_state.dart';
import 'package:galaxymob/features/movies/presentation/widgets/hero_banner.dart';

/// Collapsing SliverAppBar for Home page with hero banner integration
class HomeSliverAppBar extends StatelessWidget {
  final MovieSectionState trending;
  final VoidCallback onRetry;
  final void Function(Movie) onMovieTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  static const double expandedHeight = 480.0;
  static const double collapsedHeight = kToolbarHeight;

  const HomeSliverAppBar({
    super.key,
    required this.trending,
    required this.onRetry,
    required this.onMovieTap,
    this.onNotificationTap,
    this.onProfileTap,
  });

  bool _isLoading() =>
      (trending.status == LoadStatus.loading ||
          trending.status == LoadStatus.idle) &&
      trending.movies.isEmpty;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate collapse progress (0 = expanded, 1 = collapsed)
          final collapseProgress = _calculateCollapseProgress(
            constraints.maxHeight,
            topPadding,
          );

          return Stack(
            fit: StackFit.expand,
            children: [
              // Background: Hero Banner or Loading/Error state
              _buildBackground(),

              // Gradient overlay that intensifies as we collapse
              _buildCollapsingGradient(collapseProgress),

              // Header content (logo + actions)
              _buildHeader(context, topPadding, collapseProgress),
            ],
          );
        },
      ),
    );
  }

  double _calculateCollapseProgress(double currentHeight, double topPadding) {
    final minHeight = collapsedHeight + topPadding;
    final maxHeight = expandedHeight;
    final progress =
        1 - ((currentHeight - minHeight) / (maxHeight - minHeight));
    return progress.clamp(0.0, 1.0);
  }

  Widget _buildBackground() {
    if (_isLoading()) {
      return ShimmerLoading(
        child: ShimmerBox(
          width: double.infinity,
          height: expandedHeight,
        ),
      );
    }

    if (trending.status == LoadStatus.failure && trending.movies.isEmpty) {
      return Container(
        color: AppColors.surface,
        child: ErrorStateWidget(
          title: 'Trending unavailable',
          message: trending.error ?? 'Something went wrong',
          onRetry: onRetry,
        ),
      );
    }

    final heroMovies = trending.movies.take(5).toList();
    if (heroMovies.isEmpty) {
      return Container(color: AppColors.surface);
    }

    return HeroBanner(
      movies: heroMovies,
      onMovieTap: onMovieTap,
    );
  }

  Widget _buildCollapsingGradient(double collapseProgress) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: kToolbarHeight + 80,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              // Always have some shadow at top (0.4) for contrast, increasing to 0.95 on collapse
              AppColors.background
                  .withValues(alpha: 0.4 + (0.55 * collapseProgress)),
              Colors.transparent,
            ],
            stops: const [0.0, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    double topPadding,
    double collapseProgress,
  ) {
    return Positioned(
      top: topPadding + AppDimens.spacing12,
      left: AppDimens.spacing24,
      right: AppDimens.spacing24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo - Always high visibility
          Text(
            'GalaxyMov',
            style: AppTextStyles.h2.copyWith(
              color: AppColors.primary,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),

          // Action buttons
          Row(
            children: [
              _buildIconButton(
                icon: Icons.notifications_none,
                onTap: onNotificationTap,
              ),
              SizedBox(width: AppDimens.spacing12),
              _buildIconButton(
                icon: Icons.person_outline,
                onTap: onProfileTap,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusCircle),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.radiusCircle),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              // Increased opacity for better visibility
              color: AppColors.white.withValues(alpha: 0.15),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: AppColors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
