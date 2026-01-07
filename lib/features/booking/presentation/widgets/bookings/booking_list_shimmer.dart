import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer loading widget for bookings list
class BookingListShimmer extends StatelessWidget {
  const BookingListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: EdgeInsets.all(AppDimens.spacing16),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: AppDimens.spacing16),
            padding: EdgeInsets.all(AppDimens.spacing16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie title shimmer
                Container(
                  height: 20,
                  width: 200,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: AppDimens.spacing8),
                // Cinema name shimmer
                Container(
                  height: 16,
                  width: 150,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(height: AppDimens.spacing8),
                // Details shimmer
                Container(
                  height: 14,
                  width: 100,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
