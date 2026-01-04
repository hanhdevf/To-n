import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/core/widgets/buttons.dart';
import 'package:galaxymob/features/movies/domain/entities/movie.dart';

class FeaturedMovieCard extends StatelessWidget {
  final Movie movie;
  final String? genresLabel;
  final VoidCallback? onTap;
  final VoidCallback? onBookTap;

  const FeaturedMovieCard({
    super.key,
    required this.movie,
    this.genresLabel,
    this.onTap,
    this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 220,
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Backdrop Background
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
              child: movie.fullBackdropPath != null
                  ? CachedNetworkImage(
                      imageUrl: movie.fullBackdropPath!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.surface,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.surface,
                    ),
            ),

            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.black.withValues(alpha: 0.9),
                    AppColors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.all(AppDimens.spacing16),
              child: Row(
                children: [
                  // Poster (Small)
                  Container(
                    width: 100,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusMedium),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusMedium),
                      child: movie.fullPosterPath != null
                          ? CachedNetworkImage(
                              imageUrl: movie.fullPosterPath!,
                              fit: BoxFit.cover,
                            )
                          : Container(color: AppColors.background),
                    ),
                  ),

                  SizedBox(width: AppDimens.spacing16),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppDimens.spacing8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'FEATURED',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        SizedBox(height: AppDimens.spacing8),
                        Text(
                          movie.title,
                          style: AppTextStyles.h2.copyWith(fontSize: 20),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
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
                            if (genresLabel != null) ...[
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '• $genresLabel',
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
                        SizedBox(height: AppDimens.spacing16),
                        PrimaryButton(
                          text: 'Book Ticket',
                          onPressed: onBookTap ?? () {},
                          height: 40,
                          isFullWidth: false,
                          icon: const Icon(
                            Icons.confirmation_number_outlined,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
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
