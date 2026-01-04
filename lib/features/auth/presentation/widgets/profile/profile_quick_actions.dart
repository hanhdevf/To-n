import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';

class ProfileQuickActions extends StatelessWidget {
  final VoidCallback onBookings;
  final VoidCallback onFavorites;
  final VoidCallback onHistory;

  const ProfileQuickActions({
    super.key,
    required this.onBookings,
    required this.onFavorites,
    required this.onHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.receipt_long,
            label: 'My Bookings',
            color: AppColors.primary,
            onTap: onBookings,
          ),
        ),
        SizedBox(width: AppDimens.spacing12),
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.favorite_border,
            label: 'Favorites',
            color: AppColors.error,
            onTap: onFavorites,
          ),
        ),
        SizedBox(width: AppDimens.spacing12),
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.history,
            label: 'History',
            color: AppColors.warning,
            onTap: onHistory,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
      child: Container(
        padding: EdgeInsets.all(AppDimens.spacing16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(height: AppDimens.spacing8),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
