import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';

class ReviewSummary extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  final int ratedCount;
  final Map<int, int> ratingCounts;

  const ReviewSummary({
    super.key,
    required this.averageRating,
    required this.totalReviews,
    required this.ratedCount,
    required this.ratingCounts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.spacing16),
      color: AppColors.surface,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      averageRating > 0
                          ? averageRating.toStringAsFixed(1)
                          : 'N/A',
                      style: AppTextStyles.h1.copyWith(
                        color: AppColors.warning,
                        fontSize: 32,
                      ),
                    ),
                    SizedBox(width: AppDimens.spacing8),
                    Text(
                      '/ 10',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimens.spacing4),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < (averageRating / 2).round()
                          ? Icons.star
                          : Icons.star_border,
                      color: AppColors.warning,
                      size: 16,
                    );
                  }),
                ),
                SizedBox(height: AppDimens.spacing8),
                Text(
                  '$totalReviews reviews',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [5, 4, 3, 2, 1].map((star) {
                final count = ratingCounts[star] ?? 0;
                final percentage = ratedCount > 0 ? count / ratedCount : 0.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text(
                        '$star',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.star, size: 10, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percentage,
                            backgroundColor: AppColors.background,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.warning,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 30,
                        child: Text(
                          '$count',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
