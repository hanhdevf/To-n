import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/movies/domain/entities/movie.dart';
import 'package:galaxymob/features/cinema/domain/entities/showtime.dart';

/// Movie card with showtimes for schedule view
class ScheduleMovieCard extends StatelessWidget {
  final Movie movie;
  final List<Showtime> showtimes;
  final String? genreText;
  final VoidCallback onMovieTap;

  const ScheduleMovieCard({
    super.key,
    required this.movie,
    required this.showtimes,
    this.genreText,
    required this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    // Extract year from release date
    String year = '';
    if (movie.releaseDate.isNotEmpty && movie.releaseDate.length >= 4) {
      year = movie.releaseDate.substring(0, 4);
    }

    return GestureDetector(
      onTap: onMovieTap,
      child: Container(
        height: 144, // 18 × 8pt
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimens.radiusMedium),
                bottomLeft: Radius.circular(AppDimens.radiusMedium),
              ),
              child: SizedBox(
                width: 96, // 12 × 8pt (adjusted for better proportion)
                height: double.infinity,
                child: movie.fullPosterPath != null
                    ? CachedNetworkImage(
                        imageUrl: movie.fullPosterPath!,
                        fit: BoxFit.cover,
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
                        color: AppColors.divider,
                        child: const Icon(
                          Icons.movie_outlined,
                          color: AppColors.textTertiary,
                          size: 32,
                        ),
                      ),
              ),
            ),

            // Movie Info & Showtimes
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(AppDimens.spacing12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title & Rating
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            movie.title,
                            style: AppTextStyles.h4.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: AppDimens.spacing8),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              movie.voteAverage.toStringAsFixed(1),
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.warning,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Genre & Year
                    if (genreText != null || year.isNotEmpty) ...[
                      SizedBox(height: AppDimens.spacing4),
                      Text(
                        [genreText, year]
                            .where((s) => s != null && s.isNotEmpty)
                            .join(' • '),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    const Spacer(),

                    // Showtimes
                    if (showtimes.isNotEmpty)
                      SizedBox(
                        height: 48, // 6 × 8pt
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              showtimes.length > 4 ? 4 : showtimes.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(width: AppDimens.spacing8),
                          itemBuilder: (context, index) {
                            if (index == 3 && showtimes.length > 4) {
                              // Show "more" indicator
                              return Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: AppDimens.spacing12,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.textTertiary,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      AppDimens.radiusSmall,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '+${showtimes.length - 3}',
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }

                            final showtime = showtimes[index];
                            return _ShowtimeChip(
                              showtime: showtime,
                              formatter: formatter,
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShowtimeChip extends StatelessWidget {
  final Showtime showtime;
  final NumberFormat formatter;

  const _ShowtimeChip({
    required this.showtime,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to seat selection (we'll need movie title and cinema name)
        // For now, just navigate to showtime selection page
        // TODO: Pass proper data when integrating
      },
      borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.spacing12,
          vertical: AppDimens.spacing8,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              showtime.formattedTime,
              style: AppTextStyles.body2Medium.copyWith(
                color: AppColors.primary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              formatter.format(showtime.price),
              style: AppTextStyles.caption.copyWith(
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
