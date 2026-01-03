import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';

/// Shimmer loading effect for skeleton screens
class ShimmerLoading extends StatelessWidget {
  final Widget child;

  const ShimmerLoading({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.surface.withValues(alpha: 0.5),
      child: child,
    );
  }
}

/// Shimmer box for loading placeholders
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius:
            borderRadius ?? BorderRadius.circular(AppDimens.radiusMedium),
      ),
    );
  }
}

/// Movie card shimmer loading
class MovieCardShimmer extends StatelessWidget {
  const MovieCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(
            width: AppDimens.movieCardWidth,
            height: AppDimens.movieCardHeight,
            borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          ),
          SizedBox(height: AppDimens.spacing8),
          ShimmerBox(width: AppDimens.movieCardWidth, height: 16),
          SizedBox(height: AppDimens.spacing4),
          ShimmerBox(width: AppDimens.movieCardWidth * 0.7, height: 12),
        ],
      ),
    );
  }
}

/// Horizontal list shimmer loading
class HorizontalListShimmer extends StatelessWidget {
  final int itemCount;

  const HorizontalListShimmer({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimens.movieCardHeight + 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppDimens.spacing16),
        itemCount: itemCount,
        separatorBuilder: (context, index) =>
            SizedBox(width: AppDimens.spacing12),
        itemBuilder: (context, index) => const MovieCardShimmer(),
      ),
    );
  }
}

/// List item shimmer loading
class ListItemShimmer extends StatelessWidget {
  const ListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.spacing16,
          vertical: AppDimens.spacing12,
        ),
        child: Row(
          children: [
            ShimmerBox(
              width: 60,
              height: 60,
              borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
            ),
            SizedBox(width: AppDimens.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerBox(width: double.infinity, height: 16),
                  SizedBox(height: AppDimens.spacing8),
                  ShimmerBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Vertical list shimmer loading
class VerticalListShimmer extends StatelessWidget {
  final int itemCount;

  const VerticalListShimmer({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) => const ListItemShimmer(),
    );
  }
}
