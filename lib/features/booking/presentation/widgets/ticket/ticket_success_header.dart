import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';

class TicketSuccessHeader extends StatelessWidget {
  const TicketSuccessHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, color: AppColors.success, size: 28),
        SizedBox(width: AppDimens.spacing8),
        Text('Booking Confirmed', style: AppTextStyles.h3),
      ],
    );
  }
}
