import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';

class TicketsEmpty extends StatelessWidget {
  final bool isPast;

  const TicketsEmpty({super.key, this.isPast = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isPast ? Icons.history : Icons.confirmation_number_outlined,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
          SizedBox(height: AppDimens.spacing24),
          Text(
            isPast ? 'No past tickets' : 'No upcoming tickets',
            style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppDimens.spacing8),
          Text(
            isPast
                ? 'Your watched movies will appear here'
                : 'Book your first movie ticket!',
            style: AppTextStyles.body2,
            textAlign: TextAlign.center,
          ),
          if (!isPast) ...[
            SizedBox(height: AppDimens.spacing24),
            ElevatedButton.icon(
              onPressed: () {
                context.go('/home');
              },
              icon: const Icon(Icons.movie),
              label: const Text('Browse Movies'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.spacing24,
                  vertical: AppDimens.spacing12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
