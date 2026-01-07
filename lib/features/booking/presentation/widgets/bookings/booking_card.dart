import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final bool isActive;
  final bool hasTicket;
  final VoidCallback? onCancel;
  final VoidCallback? onViewTicket;
  final VoidCallback? onGenerateTicket;

  const BookingCard({
    super.key,
    required this.booking,
    required this.isActive,
    this.hasTicket = false,
    this.onCancel,
    this.onViewTicket,
    this.onGenerateTicket,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('EEE, MMM d, yyyy');
    final timeFormatter = DateFormat('HH:mm');
    final priceFormatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    final isCancelled = booking.status == BookingStatus.cancelled;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        border: isCancelled
            ? Border.all(color: AppColors.error.withValues(alpha: 0.3))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(AppDimens.spacing16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isCancelled
                    ? [
                        AppColors.error.withValues(alpha: 0.2),
                        AppColors.error.withValues(alpha: 0.1),
                      ]
                    : [
                        AppColors.primary.withValues(alpha: 0.2),
                        AppColors.primary.withValues(alpha: 0.1),
                      ],
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimens.radiusMedium),
                topRight: Radius.circular(AppDimens.radiusMedium),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.movieTitle,
                        style: AppTextStyles.h3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: AppDimens.spacing4),
                      Text(
                        'ID: ${booking.id}',
                        style: AppTextStyles.caption.copyWith(
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                if (isCancelled)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimens.spacing8,
                      vertical: AppDimens.spacing4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius:
                          BorderRadius.circular(AppDimens.radiusSmall),
                    ),
                    child: Text(
                      'CANCELLED',
                      style: AppTextStyles.caption.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppDimens.spacing16),
            child: Column(
              children: [
                _DetailRow(
                  icon: Icons.location_on,
                  label: 'Cinema',
                  value: booking.cinemaName,
                ),
                SizedBox(height: AppDimens.spacing12),
                _DetailRow(
                  icon: Icons.calendar_today,
                  label: 'Date & Time',
                  value:
                      '${dateFormatter.format(booking.showtime)} • ${timeFormatter.format(booking.showtime)}',
                ),
                SizedBox(height: AppDimens.spacing12),
                _DetailRow(
                  icon: Icons.event_seat,
                  label: 'Seats',
                  value: booking.formattedSeats,
                ),
                SizedBox(height: AppDimens.spacing12),
                _DetailRow(
                  icon: Icons.payment,
                  label: 'Total',
                  value: priceFormatter.format(booking.totalPrice),
                  valueColor: AppColors.primary,
                  valueWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
          if (isActive && !isCancelled) ...[
            Divider(
                height: 1,
                color: AppColors.textSecondary.withValues(alpha: 0.1)),
            Padding(
              padding: EdgeInsets.all(AppDimens.spacing12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onCancel,
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        padding: EdgeInsets.symmetric(
                          vertical: AppDimens.spacing12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppDimens.spacing8),
                  Expanded(
                    flex: 2,
                    child: hasTicket
                        ? ElevatedButton.icon(
                            onPressed: onViewTicket,
                            icon: const Icon(Icons.qr_code, size: 18),
                            label: const Text('View Ticket'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: AppDimens.spacing12,
                              ),
                            ),
                          )
                        : ElevatedButton.icon(
                            onPressed: onGenerateTicket,
                            icon: const Icon(Icons.qr_code_2, size: 18),
                            label: const Text('Generate Ticket'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                vertical: AppDimens.spacing12,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
  final FontWeight? valueWeight;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
    this.valueWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        SizedBox(width: AppDimens.spacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.body2.copyWith(
                  color: valueColor,
                  fontWeight: valueWeight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
