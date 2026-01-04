import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/movies/domain/entities/movie.dart';

class GridMovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;

  const GridMovieCard({
    super.key,
    required this.movie,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Extract year from release date (format: YYYY-MM-DD)
    String year = '';
    if (movie.releaseDate.isNotEmpty && movie.releaseDate.length >= 4) {
      year = movie.releaseDate.substring(0, 4);
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster Image
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                child: movie.fullPosterPath != null
                    ? CachedNetworkImage(
                        imageUrl: movie.fullPosterPath!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) => Container(
                          color: AppColors.surface,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.surface,
                          child: const Icon(
                            Icons.movie_outlined,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      )
                    : Container(
                        color: AppColors.surface,
                        child: const Icon(
                          Icons.movie_outlined,
                          color: AppColors.textTertiary,
                          size: 32,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(height: AppDimens.spacing8),

          // Title
          Text(
            movie.title,
            style: AppTextStyles.body2Medium.copyWith(
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 2),

          // Rating & Year
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                size: 14,
                color: AppColors.warning,
              ),
              SizedBox(width: 4),
              Text(
                movie.voteAverage.toStringAsFixed(1),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.warning,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (year.isNotEmpty) ...[
                SizedBox(width: 8),
                Text(
                  '•',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
                SizedBox(width: 8),
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
    );
  }
}
