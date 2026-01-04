import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/movies/domain/entities/movie.dart';

class TimelineMovieCard extends StatelessWidget {
  final Movie movie;
  final String? genresLabel;
  final VoidCallback? onTap;

  const TimelineMovieCard({
    super.key,
    required this.movie,
    this.genresLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        margin: EdgeInsets.only(bottom: AppDimens.spacing16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Poster Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimens.radiusMedium),
                bottomLeft: Radius.circular(AppDimens.radiusMedium),
              ),
              child: movie.fullPosterPath != null
                  ? CachedNetworkImage(
                      imageUrl: movie.fullPosterPath!,
                      width: 100,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 100,
                        color: AppColors.background,
                      ),
                    )
                  : Container(
                      width: 100,
                      color: AppColors.background,
                      child: const Icon(
                        Icons.movie_outlined,
                        color: AppColors.textTertiary,
                      ),
                    ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppDimens.spacing12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    Text(
                      movie.title,
                      style: AppTextStyles.h3.copyWith(fontSize: 18),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: AppDimens.spacing8),

                    // Rating & Year
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.warning,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text(
                          movie.voteAverage.toStringAsFixed(1),
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.warning,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: AppDimens.spacing12),
                        Icon(
                          Icons.calendar_today,
                          color: AppColors.textTertiary,
                          size: 14,
                        ),
                        SizedBox(width: 4),
                        Text(
                          movie.releaseDate.isNotEmpty
                              ? movie.releaseDate.split('-')[0] // Year
                              : 'N/A',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),

                    SizedBox(height: AppDimens.spacing8),

                    // Genres
                    if (genresLabel != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimens.spacing8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(AppDimens.radiusSmall),
                        ),
                        child: Text(
                          genresLabel!,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Arrow indicator
            Padding(
              padding: EdgeInsets.only(right: AppDimens.spacing16),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.textTertiary.withValues(alpha: 0.5),
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
