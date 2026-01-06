import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';

class BookingSummaryDetails extends StatelessWidget {
  final String cinemaName;
  final String showtime;
  final List<String> selectedSeats;
  final double totalPrice;

  const BookingSummaryDetails({
    super.key,
    required this.cinemaName,
    required this.showtime,
    required this.selectedSeats,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    final bookingFee = totalPrice * 0.05;
    final finalTotal = totalPrice + bookingFee;

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
          Text('Booking Details', style: AppTextStyles.h3),
          Divider(height: 24, color: Colors.white24),
          _buildDetailRow('Cinema', cinemaName, icon: Icons.location_on),
          SizedBox(height: AppDimens.spacing12),
          _buildDetailRow('Date & Time', showtime, icon: Icons.access_time),
          SizedBox(height: AppDimens.spacing12),
          _buildDetailRow('Seats', selectedSeats.join(', '),
              icon: Icons.event_seat),
          SizedBox(height: AppDimens.spacing12),
          _buildDetailRow('Tickets', '${selectedSeats.length}x',
              icon: Icons.confirmation_number),
          Divider(height: 24, color: Colors.white24),
          _buildPriceRow('Subtotal', totalPrice, formatter),
          SizedBox(height: AppDimens.spacing8),
          _buildPriceRow('Booking Fee (5%)', bookingFee, formatter),
          Divider(height: 24, color: Colors.white24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Amount', style: AppTextStyles.h3),
              Text(
                formatter.format(finalTotal),
                style: AppTextStyles.h2.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {IconData? icon}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: AppColors.textSecondary),
          SizedBox(width: AppDimens.spacing8),
        ],
        Expanded(
          flex: 2,
          child: Text(label, style: AppTextStyles.body2),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(
    String label,
    double amount,
    NumberFormat formatter,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.body2),
        Text(
          formatter.format(amount),
          style: AppTextStyles.body1,
        ),
      ],
    );
  }
}
