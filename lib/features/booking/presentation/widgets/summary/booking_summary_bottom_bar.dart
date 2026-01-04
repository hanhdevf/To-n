import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/core/widgets/buttons.dart';

class BookingSummaryBottomBar extends StatelessWidget {
  final bool isProcessing;
  final VoidCallback onConfirm;

  const BookingSummaryBottomBar({
    super.key,
    required this.isProcessing,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: PrimaryButton(
          text: isProcessing ? 'Processing...' : 'Confirm & Pay',
          onPressed: isProcessing ? null : onConfirm,
        ),
      ),
    );
  }
}
