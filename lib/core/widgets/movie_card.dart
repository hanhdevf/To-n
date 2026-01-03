import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';

/// Movie card widget (portrait orientation)
class MovieCard extends StatelessWidget {
  final String title;
  final String? posterPath;
  final double? rating;
  final String? genre;
  final VoidCallback? onTap;

  const MovieCard({
    super.key,
    required this.title,
    this.posterPath,
    this.rating,
    this.genre,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimens.movieCardWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          child: Stack(
            children: [
              // Poster Image
              if (posterPath != null)
                CachedNetworkImage(
                  imageUrl: posterPath!,
                  width: AppDimens.movieCardWidth,
                  height: AppDimens.movieCardHeight,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: AppDimens.movieCardWidth,
                    height: AppDimens.movieCardHeight,
                    color: AppColors.surface,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: AppDimens.movieCardWidth,
                    height: AppDimens.movieCardHeight,
                    color: AppColors.surface,
                    child: const Icon(
                      Icons.movie_outlined,
                      size: 48,
                      color: AppColors.textTertiary,
                    ),
                  ),
                )
              else
                Container(
                  width: AppDimens.movieCardWidth,
                  height: AppDimens.movieCardHeight,
                  color: AppColors.surface,
                  child: const Icon(
                    Icons.movie_outlined,
                    size: 48,
                    color: AppColors.textTertiary,
                  ),
                ),

              // Gradient Overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.black.withValues(alpha: 0.9),
                      ],
                    ),
                  ),
                ),
              ),

              // Movie Info
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.all(AppDimens.spacing12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.body2Medium.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppDimens.spacing4),
                      Row(
                        children: [
                          if (rating != null) ...[
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: AppColors.warning,
                            ),
                            SizedBox(width: AppDimens.spacing4),
                            Text(
                              rating!.toStringAsFixed(1),
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.warning,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                          if (genre != null && rating != null) ...[
                            SizedBox(width: AppDimens.spacing8),
                            Text(
                              '•',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                            SizedBox(width: AppDimens.spacing8),
                          ],
                          if (genre != null)
                            Expanded(
                              child: Text(
                                genre!,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.textTertiary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
