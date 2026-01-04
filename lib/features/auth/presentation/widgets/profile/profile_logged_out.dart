import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/core/widgets/widgets.dart';

class ProfileLoggedOut extends StatelessWidget {
  const ProfileLoggedOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimens.spacing24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: 100,
              color: AppColors.textSecondary.withValues(alpha: 0.3),
            ),
            SizedBox(height: AppDimens.spacing24),
            Text(
              'Not Logged In',
              style: AppTextStyles.h2,
            ),
            SizedBox(height: AppDimens.spacing8),
            Text(
              'Please login to view your profile',
              style: AppTextStyles.body1.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimens.spacing32),
            PrimaryButton(
              text: 'Login',
              onPressed: () => context.go('/login'),
            ),
            SizedBox(height: AppDimens.spacing12),
            SecondaryButton(
              text: 'Register',
              onPressed: () => context.go('/register'),
            ),
          ],
        ),
      ),
    );
  }
}
