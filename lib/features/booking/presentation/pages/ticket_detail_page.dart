import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/booking/domain/entities/ticket.dart';
import 'package:galaxymob/core/widgets/buttons.dart';

class TicketDetailPage extends StatelessWidget {
  final Ticket ticket;

  const TicketDetailPage({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM d, yyyy');
    final timeFormat = DateFormat('HH:mm');
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Ticket Details', style: AppTextStyles.h3),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimens.spacing24),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Movie Header (Mock Image if no poster)
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppDimens.radiusLarge),
                      ),
                    ),
                    child: Center(
                      child:
                          Icon(Icons.movie, size: 60, color: AppColors.primary),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(AppDimens.spacing24),
                    child: Column(
                      children: [
                        // Movie Title
                        Text(
                          ticket.booking.movieTitle,
                          style: AppTextStyles.h2,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: AppDimens.spacing8),

                        // Status Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: ticket.isValid
                                ? AppColors.success.withValues(alpha: 0.1)
                                : Colors.white10,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: ticket.isValid
                                  ? AppColors.success
                                  : AppColors.textSecondary,
                            ),
                          ),
                          child: Text(
                            ticket.isValid ? 'VALID TICKET' : 'USED / EXPIRED',
                            style: AppTextStyles.caption.copyWith(
                              color: ticket.isValid
                                  ? AppColors.success
                                  : AppColors.textSecondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(height: AppDimens.spacing24),

                        // Info Grid
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInfoColumn(
                              'DATE',
                              dateFormat.format(ticket.booking.showtime),
                              CrossAxisAlignment.start,
                            ),
                            _buildInfoColumn(
                              'TIME',
                              timeFormat.format(ticket.booking.showtime),
                              CrossAxisAlignment.end,
                            ),
                          ],
                        ),
                        SizedBox(height: AppDimens.spacing16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildInfoColumn(
                              'CINEMA',
                              ticket.booking.cinemaName,
                              CrossAxisAlignment.start,
                            ),
                            _buildInfoColumn(
                              'SEATS',
                              ticket.booking.formattedSeats,
                              CrossAxisAlignment.end,
                            ),
                          ],
                        ),

                        SizedBox(height: AppDimens.spacing24),
                        Divider(color: Colors.white24, thickness: 1),
                        SizedBox(height: AppDimens.spacing24),

                        // QR Code
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: QrImageView(
                            data: ticket.qrData,
                            version: QrVersions.auto,
                            size: 200.0,
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                          ),
                        ),
                        SizedBox(height: AppDimens.spacing16),
                        Text(
                          'ID: ${ticket.booking.id}',
                          style: AppTextStyles.body2.copyWith(
                            fontFamily: 'Courier',
                            letterSpacing: 1.5,
                          ),
                        ),

                        SizedBox(height: AppDimens.spacing24),
                        Divider(color: Colors.white24, thickness: 1),
                        SizedBox(height: AppDimens.spacing24),

                        // Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Paid', style: AppTextStyles.body1),
                            Text(
                              currencyFormat.format(ticket.booking.totalPrice),
                              style: AppTextStyles.h2.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppDimens.spacing24),

            // Action Buttons
            PrimaryButton(
              text: 'Save Screen',
              onPressed: () {
                // Mock save action
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Ticket saved to gallery (Mock)')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(
      String label, String value, CrossAxisAlignment align) {
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
