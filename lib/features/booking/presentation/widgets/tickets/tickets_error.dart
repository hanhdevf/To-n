import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';

class TicketsError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const TicketsError({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.error),
          SizedBox(height: AppDimens.spacing16),
          Text('Error loading tickets', style: AppTextStyles.h3),
          SizedBox(height: AppDimens.spacing8),
          Text(message, style: AppTextStyles.body2),
          SizedBox(height: AppDimens.spacing24),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
