import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';

class SeatLegend extends StatelessWidget {
  const SeatLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.spacing16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _LegendItem('Available', AppColors.surface, Colors.grey),
          _LegendItem('Selected', AppColors.warning, AppColors.warning),
          _LegendItem('Booked', AppColors.error, AppColors.error),
          _LegendItem('VIP', AppColors.primary, AppColors.primary),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color fillColor;
  final Color borderColor;

  const _LegendItem(this.label, this.fillColor, this.borderColor);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: fillColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: AppDimens.spacing4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
