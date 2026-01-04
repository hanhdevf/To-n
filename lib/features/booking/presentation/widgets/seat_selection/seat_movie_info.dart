import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';

class SeatMovieInfo extends StatelessWidget {
  final String movieTitle;
  final String cinemaName;
  final String showtime;

  const SeatMovieInfo({
    super.key,
    required this.movieTitle,
    required this.cinemaName,
    required this.showtime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.spacing16),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(movieTitle, style: AppTextStyles.h3, maxLines: 1),
          SizedBox(height: AppDimens.spacing4),
          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
              SizedBox(width: AppDimens.spacing4),
              Expanded(
                child: Text(
                  cinemaName,
                  style: AppTextStyles.caption,
                  maxLines: 1,
                ),
              ),
              SizedBox(width: AppDimens.spacing8),
              Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
              SizedBox(width: AppDimens.spacing4),
              Text(showtime, style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }
}
