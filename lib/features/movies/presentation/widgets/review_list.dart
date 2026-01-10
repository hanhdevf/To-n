import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/config/routes/route_args.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/movies/domain/entities/review.dart';

class ReviewList extends StatelessWidget {
  final List<Review> reviews;
  final String movieTitle;

  const ReviewList({
    super.key,
    required this.reviews,
    required this.movieTitle,
  });

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const SizedBox.shrink();
    }

    // Take top 5 reviews for preview
    final displayReviews = reviews.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.spacing24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Reviews', style: AppTextStyles.h3),
              GestureDetector(
                onTap: () {
                  context.pushNamed(
                    'all_reviews',
                    extra: AllReviewsArgs(
                      reviews: reviews,
                      movieTitle: movieTitle,
                    ),
                  );
                },
                child: Text(
                  'View All',
                  style: AppTextStyles.body2Medium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimens.spacing16),
        SizedBox(
          height: 180,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.spacing24),
            scrollDirection: Axis.horizontal,
            itemCount: displayReviews.length,
            separatorBuilder: (context, index) =>
                SizedBox(width: AppDimens.spacing16),
            itemBuilder: (context, index) {
              final review = displayReviews[index];
              return Container(
                width: 300,
                padding: EdgeInsets.all(AppDimens.spacing16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.1),
                          backgroundImage: review.fullAvatarPath != null
                              ? CachedNetworkImageProvider(
                                  review.fullAvatarPath!)
                              : null,
                          child: review.fullAvatarPath == null
                              ? Text(
                                  review.author.isNotEmpty
                                      ? review.author[0].toUpperCase()
                                      : 'U',
                                  style: const TextStyle(
                                      color: AppColors.primary, fontSize: 14),
                                )
                              : null,
                        ),
                        SizedBox(width: AppDimens.spacing8),
                        Expanded(
                          child: Text(
                            review.author,
                            style: AppTextStyles.body2Medium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (review.rating != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star,
                                    size: 12, color: AppColors.warning),
                                const SizedBox(width: 4),
                                Text(
                                  review.rating!.toString(),
                                  style: AppTextStyles.caption.copyWith(
                                    color: AppColors.warning,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: AppDimens.spacing12),
                    Expanded(
                      child: Text(
                        review.content,
                        style: AppTextStyles.body2.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
