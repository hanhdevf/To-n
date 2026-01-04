import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';

class BookingPaymentMethodDropdown extends StatelessWidget {
  final PaymentMethod selected;
  final ValueChanged<PaymentMethod?> onChanged;

  const BookingPaymentMethodDropdown({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimens.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Payment Method', style: AppTextStyles.h3),
          SizedBox(height: AppDimens.spacing16),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: AppDimens.spacing16),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
              border: Border.all(color: Colors.white24),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<PaymentMethod>(
                value: selected,
                isExpanded: true,
                dropdownColor: AppColors.surface,
                icon: Icon(Icons.arrow_drop_down, color: AppColors.primary),
                style: AppTextStyles.body1,
                onChanged: onChanged,
                items: [
                  _buildDropdownItem(
                    PaymentMethod.creditCard,
                    'Credit/Debit Card',
                    Icons.credit_card,
                  ),
                  _buildDropdownItem(
                    PaymentMethod.momo,
                    'MoMo E-Wallet',
                    Icons.account_balance_wallet,
                  ),
                  _buildDropdownItem(
                    PaymentMethod.zaloPay,
                    'ZaloPay',
                    Icons.payment,
                  ),
                  _buildDropdownItem(
                    PaymentMethod.vnPay,
                    'VNPay',
                    Icons.account_balance,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<PaymentMethod> _buildDropdownItem(
    PaymentMethod method,
    String name,
    IconData icon,
  ) {
    return DropdownMenuItem<PaymentMethod>(
      value: method,
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          SizedBox(width: AppDimens.spacing12),
          Text(name, style: AppTextStyles.body1),
        ],
      ),
    );
  }
}
