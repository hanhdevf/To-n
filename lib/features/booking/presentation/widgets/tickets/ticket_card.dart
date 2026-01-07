import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/booking/domain/entities/ticket.dart';

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  final bool isPast;
  final VoidCallback onTap;

  const TicketCard({
    super.key,
    required this.ticket,
    required this.onTap,
    this.isPast = false,
  });

  @override
  Widget build(BuildContext context) {
    final formatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    final dateFormat = DateFormat('EEE, MMM d, HH:mm');

    return Container(
      margin: EdgeInsets.only(bottom: AppDimens.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        border: Border.all(
          color:
              isPast ? Colors.white12 : AppColors.primary.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          child: Padding(
            padding: EdgeInsets.all(AppDimens.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ticket.booking.movieTitle,
                        style: AppTextStyles.h3,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!isPast && ticket.isValid)
                      _buildStatusChip('VALID', AppColors.success)
                    else if (isPast)
                      _buildStatusChip('USED', AppColors.textSecondary),
                  ],
                ),
                SizedBox(height: AppDimens.spacing12),
                Row(
                  children: [
                    Icon(Icons.location_on,
                        size: 16, color: AppColors.textSecondary),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        ticket.booking.cinemaName,
                        style: AppTextStyles.body2,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimens.spacing4),
                Row(
                  children: [
                    Icon(Icons.access_time,
                        size: 16, color: AppColors.textSecondary),
                    SizedBox(width: 4),
                    Text(
                      dateFormat.format(ticket.booking.showtime),
                      style: AppTextStyles.body2,
                    ),
                  ],
                ),
                SizedBox(height: AppDimens.spacing4),
                Row(
                  children: [
                    Icon(Icons.event_seat,
                        size: 16, color: AppColors.textSecondary),
                    SizedBox(width: 4),
                    Text(
                      ticket.booking.formattedSeats,
                      style: AppTextStyles.body2,
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
                        Text('Booking ID', style: AppTextStyles.caption),
                        Text(
                          ticket.booking.id,
                          style: AppTextStyles.body2.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      formatter.format(ticket.booking.totalPrice),
                      style: AppTextStyles.h3.copyWith(
                        color: isPast
                            ? AppColors.textSecondary
                            : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
