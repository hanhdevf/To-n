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
  final String? releaseDate;
  final VoidCallback? onTap;

  const MovieCard({
    super.key,
    required this.title,
    this.posterPath,
    this.rating,
    this.genre,
    this.releaseDate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Extract year
    String? year;
    if (releaseDate != null && releaseDate!.length >= 4) {
      year = releaseDate!.substring(0, 4);
    }

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
                  height: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: AppDimens.movieCardWidth,
                    color: AppColors.surface,
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: AppDimens.movieCardWidth,
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
                  height: 120, // Increased height for more content
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
                      // Genre badge (if available)
                      if (genre != null && genre!.isNotEmpty)
                        Container(
                          margin: EdgeInsets.only(bottom: AppDimens.spacing8),
                          padding: EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            genre!
                                .toUpperCase()
                                .split(', ')[0], // First genre only
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),

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
                          if (year != null) ...[
                            SizedBox(width: AppDimens.spacing8),
                            Text(
                              year,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
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
