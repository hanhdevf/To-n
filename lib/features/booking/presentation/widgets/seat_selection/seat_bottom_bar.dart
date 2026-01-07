import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/config/routes/heplers/route_args.dart';
import 'package:galaxymob/features/booking/presentation/bloc/seat_state.dart';

class SeatBottomBar extends StatelessWidget {
  final SeatLayoutLoaded state;
  final String movieTitle;
  final String cinemaName;
  final String showtime;
  final DateTime? showtimeDateTime;
  final String showtimeId;
  final String? movieId;
  final String? cinemaId;

  const SeatBottomBar({
    super.key,
    required this.state,
    required this.movieTitle,
    required this.cinemaName,
    required this.showtime,
    this.showtimeDateTime,
    required this.showtimeId,
    this.movieId,
    this.cinemaId,
  });

  @override
  Widget build(BuildContext context) {
    final formatter =
        NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);

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
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${state.selectedCount} Seat${state.selectedCount > 1 ? 's' : ''}',
                    style: AppTextStyles.body2,
                  ),
                  Text(
                    formatter.format(state.totalPrice),
                    style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppDimens.spacing12),
            Flexible(
              child: ElevatedButton(
                onPressed: () {
                  context.pushNamed(
                    'bookingSummary',
                    extra: BookingSummaryArgs(
                      movieTitle: movieTitle,
                      cinemaName: cinemaName,
                      showtime: showtime,
                      showtimeDateTime: showtimeDateTime,
                      selectedSeats: state.selectedSeats,
                      totalPrice: state.totalPrice,
                      showtimeId: showtimeId,
                      movieId: movieId,
                      cinemaId: cinemaId,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimens.spacing24,
                    vertical: AppDimens.spacing16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                  ),
                ),
                child: Text('Continue', style: AppTextStyles.button),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
