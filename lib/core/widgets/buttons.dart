import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';

/// Primary button widget with gradient background and shadow
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final double? height;
  final Widget? icon;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? AppDimens.buttonHeight;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: buttonHeight,
      child: Container(
        decoration: BoxDecoration(
          gradient: onPressed == null
              ? null
              : const LinearGradient(
                  colors: [AppColors.gradientStart, AppColors.gradientEnd],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: onPressed == null ? AppColors.disabled : null,
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          boxShadow: onPressed == null
              ? null
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
            onTap: isLoading ? null : onPressed,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: AppDimens.spacing24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  if (icon != null && !isLoading) ...[
                    icon!,
                    SizedBox(width: AppDimens.spacing8),
                  ],
                  if (isLoading)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.white,
                        ),
                      ),
                    )
                  else
                    Text(
                      text,
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Secondary button with outline style
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final double? height;
  final Widget? icon;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? AppDimens.buttonHeight;

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: buttonHeight,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(
            color: onPressed == null ? AppColors.disabled : AppColors.primary,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          ),
          padding: EdgeInsets.symmetric(horizontal: AppDimens.spacing24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          children: [
            if (icon != null && !isLoading) ...[
              icon!,
              SizedBox(width: AppDimens.spacing8),
            ],
            if (isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            else
              Text(
                text,
                style: AppTextStyles.button.copyWith(
                  color: onPressed == null
                      ? AppColors.disabled
                      : AppColors.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
