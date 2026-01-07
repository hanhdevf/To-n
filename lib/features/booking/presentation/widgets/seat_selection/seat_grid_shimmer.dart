import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer loading widget for seat grid
class SeatGridShimmer extends StatelessWidget {
  const SeatGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimens.spacing16),
        child: Column(
          children: [
            // Build 8 rows of shimmer seats
            ...List.generate(
              8,
              (rowIndex) => Padding(
                padding: EdgeInsets.only(bottom: AppDimens.spacing8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Left side seats
                    ...List.generate(
                      rowIndex < 2 ? 4 : 5,
                      (seatIndex) => Container(
                        width: 28,
                        height: 28,
                        margin: EdgeInsets.symmetric(
                          horizontal: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    SizedBox(width: AppDimens.spacing16),
                    // Right side seats
                    ...List.generate(
                      rowIndex < 2 ? 4 : 5,
                      (seatIndex) => Container(
                        width: 28,
                        height: 28,
                        margin: EdgeInsets.symmetric(
                          horizontal: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6),
                        ),
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
