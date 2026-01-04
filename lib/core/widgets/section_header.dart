import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';

/// Section header with title and optional "See All" action
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
    this.icon,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: AppDimens.spacing16,
            vertical: AppDimens.spacing8,
          ),
      child: Row(
        children: [
          if (icon != null) ...[icon!, SizedBox(width: AppDimens.spacing8)],
          Expanded(child: Text(title, style: AppTextStyles.h3)),
          if (actionText != null && onActionTap != null)
            InkWell(
              onTap: onActionTap,
              borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
              child: Padding(
                padding: EdgeInsets.all(AppDimens.spacing8),
                child: Row(
                  children: [
                    Text(
                      actionText!,
                      style: AppTextStyles.body2Medium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: AppDimens.spacing4),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
