import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';
import 'package:galaxymob/features/booking/domain/entities/ticket.dart';

class TicketQrCard extends StatelessWidget {
  final Ticket ticket;
  final String movieTitle;
  final String cinemaName;
  final String showtime;
  final List<String> selectedSeats;
  final String userName;
  final PaymentMethod paymentMethod;
  final double totalPrice;

  const TicketQrCard({
    super.key,
    required this.ticket,
    required this.movieTitle,
    required this.cinemaName,
    required this.showtime,
    required this.selectedSeats,
    required this.userName,
    required this.paymentMethod,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(AppDimens.spacing24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimens.radiusLarge),
                topRight: Radius.circular(AppDimens.radiusLarge),
              ),
            ),
            child: Column(
              children: [
                Text(
                  movieTitle,
                  style: AppTextStyles.h2.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppDimens.spacing8),
                Text(
                  'E-Ticket',
                  style: AppTextStyles.caption.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          _buildPerforation(),
          Padding(
            padding: EdgeInsets.all(AppDimens.spacing16),
            child: Column(
              children: [
                _buildQRCode(),
                SizedBox(height: AppDimens.spacing16),
                _buildTicketInfo(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerforation() {
    return Row(
      children: List.generate(
        20,
        (index) => Expanded(
          child: Container(
            height: 2,
            color: index.isEven ? AppColors.surface : AppColors.background,
          ),
        ),
      ),
    );
  }

  Widget _buildQRCode() {
    return Container(
      padding: EdgeInsets.all(AppDimens.spacing12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
        border: Border.all(color: AppColors.primary, width: 2),
      ),
      child: QrImageView(
        data: ticket.qrData,
        version: QrVersions.auto,
        size: 160,
        backgroundColor: Colors.white,
        eyeStyle: QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: AppColors.primary,
        ),
        dataModuleStyle: QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTicketInfo() {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.spacing12,
            vertical: AppDimens.spacing8,
          ),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Booking ID', style: AppTextStyles.caption),
              Text(
                ticket.booking.id,
                style: AppTextStyles.body2.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimens.spacing12),
        Row(
          children: [
            Expanded(
              child: _buildCompactInfoItem(
                Icons.location_on,
                'Cinema',
                cinemaName,
              ),
            ),
            SizedBox(width: AppDimens.spacing8),
            Expanded(
              child: _buildCompactInfoItem(
                Icons.access_time,
                'Time',
                showtime,
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimens.spacing8),
        Row(
          children: [
            Expanded(
              child: _buildCompactInfoItem(
                Icons.event_seat,
                'Seats',
                selectedSeats.join(', '),
              ),
            ),
            SizedBox(width: AppDimens.spacing8),
            Expanded(
              child: _buildCompactInfoItem(
                Icons.person,
                'Name',
                userName,
              ),
            ),
          ],
        ),
        Divider(height: 24, color: Colors.white24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Paid', style: AppTextStyles.body2),
                SizedBox(height: 2),
                Text(
                  'via ${paymentMethod.displayName}',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
            Text(
              formatter.format(totalPrice),
              style: AppTextStyles.h3.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompactInfoItem(IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.all(AppDimens.spacing8),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppColors.textSecondary),
              SizedBox(width: 4),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
