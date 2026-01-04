import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';

class MovieDetailSynopsis extends StatelessWidget {
  final String overview;
  final bool isExpanded;
  final VoidCallback onToggle;

  const MovieDetailSynopsis({
    super.key,
    required this.overview,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.spacing24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Synopsis', style: AppTextStyles.h3),
          SizedBox(height: AppDimens.spacing8),
          Text(
            overview,
            style: AppTextStyles.body1,
            maxLines: isExpanded ? null : 3,
            overflow: isExpanded ? null : TextOverflow.ellipsis,
          ),
          if (overview.length > 100)
            GestureDetector(
              onTap: onToggle,
              child: Padding(
                padding: EdgeInsets.only(top: AppDimens.spacing8),
                child: Text(
                  isExpanded ? 'Read Less' : 'Read More',
                  style: AppTextStyles.body2Medium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
