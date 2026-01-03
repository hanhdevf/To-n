import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/booking/domain/entities/seat.dart';
import 'package:galaxymob/features/booking/presentation/bloc/seat_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/seat_event.dart';
import 'package:galaxymob/features/booking/presentation/bloc/seat_state.dart';

/// Seat selection page with interactive grid
class SeatSelectionPage extends StatelessWidget {
  final String showtimeId;
  final String movieTitle;
  final String cinemaName;
  final String showtime;
  final double basePrice;

  const SeatSelectionPage({
    super.key,
    required this.showtimeId,
    required this.movieTitle,
    required this.cinemaName,
    required this.showtime,
    required this.basePrice,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Seats', style: AppTextStyles.h3),
        backgroundColor: AppColors.background,
      ),
      body: Column(
        children: [
          // Movie info header
          _buildMovieInfo(),

          // Screen indicator
          _buildScreenIndicator(),

          // Legend
          _buildLegend(),

          // Seat grid
          Expanded(
            child: BlocBuilder<SeatBloc, SeatState>(
              builder: (context, state) {
                if (state is SeatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SeatLayoutLoaded) {
                  return _buildSeatGrid(context, state);
                } else if (state is SeatError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      // Bottom bar with selected info
      bottomNavigationBar: BlocBuilder<SeatBloc, SeatState>(
        builder: (context, state) {
          if (state is! SeatLayoutLoaded || state.selectedCount == 0) {
            return const SizedBox.shrink();
          }

          return _buildBottomBar(context, state);
        },
      ),
    );
  }

  Widget _buildMovieInfo() {
    return Container(
      padding: EdgeInsets.all(AppDimens.spacing16),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(movieTitle, style: AppTextStyles.h3, maxLines: 1),
          SizedBox(height: AppDimens.spacing4),
          Row(
            children: [
              Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
              SizedBox(width: AppDimens.spacing4),
              Expanded(
                child: Text(
                  cinemaName,
                  style: AppTextStyles.caption,
                  maxLines: 1,
                ),
              ),
              SizedBox(width: AppDimens.spacing8),
              Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
              SizedBox(width: AppDimens.spacing4),
              Text(showtime, style: AppTextStyles.caption),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScreenIndicator() {
    return Container(
      margin: EdgeInsets.all(AppDimens.spacing24),
      padding: EdgeInsets.symmetric(vertical: AppDimens.spacing8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.3),
            AppColors.primary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
      ),
      child: Center(
        child: Text(
          'SCREEN',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.spacing16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLegendItem('Available', AppColors.surface, Colors.grey),
          _buildLegendItem('Selected', AppColors.warning, AppColors.warning),
          _buildLegendItem('Booked', AppColors.error, AppColors.error),
          _buildLegendItem('VIP', AppColors.primary, AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color fillColor, Color borderColor) {
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

  Widget _buildSeatGrid(BuildContext context, SeatLayoutLoaded state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimens.spacing16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: state.seatLayout.asMap().entries.map((entry) {
            final rowIndex = entry.key;
            final rowSeats = entry.value;

            // Determine split point based on row
            // Front rows (0, 1): 4-4, Middle/Back (2-7): 5-5
            final splitPoint = rowIndex < 2 ? 4 : 5;

            final leftSeats = rowSeats.take(splitPoint).toList();
            final rightSeats = rowSeats.skip(splitPoint).toList();

            // Get row letter from first seat
            final rowLetter = rowSeats.isNotEmpty ? rowSeats.first.row : '';

            return Padding(
              padding: EdgeInsets.only(bottom: AppDimens.spacing8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Row label
                  SizedBox(
                    width: 24,
                    child: Text(
                      rowLetter,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(width: AppDimens.spacing8),

                  // Left side seats
                  ...leftSeats.map((seat) => _buildSeatWidget(context, seat)),

                  // Center aisle (gap)
                  SizedBox(width: AppDimens.spacing24),

                  // Right side seats
                  ...rightSeats.map((seat) => _buildSeatWidget(context, seat)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSeatWidget(BuildContext context, Seat seat) {
    Color getSeatColor() {
      switch (seat.status) {
        case SeatStatus.available:
          return seat.type == SeatType.vip
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.surface;
        case SeatStatus.selected:
          return AppColors.warning;
        case SeatStatus.booked:
          return AppColors.error;
      }
    }

    Color getBorderColor() {
      switch (seat.type) {
        case SeatType.vip:
          return AppColors.primary;
        case SeatType.couple:
          return AppColors.secondary;
        default:
          return Colors.grey;
      }
    }

    return Padding(
      padding: EdgeInsets.all(2),
      child: GestureDetector(
        key: ValueKey(seat.id), // Add key for proper widget identity
        onTap: () {
          if (seat.status != SeatStatus.booked) {
            context.read<SeatBloc>().add(ToggleSeatEvent(seat));
          }
        },
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: getSeatColor(),
            border: Border.all(color: getBorderColor()),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              seat.number.toString(),
              style: TextStyle(
                fontSize: 10,
                color: seat.status == SeatStatus.selected
                    ? AppColors.background
                    : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, SeatLayoutLoaded state) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

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
                    extra: {
                      'movieTitle': movieTitle,
                      'cinemaName': cinemaName,
                      'showtime': showtime,
                      'selectedSeats': state.selectedSeats
                          .map((s) => s.displayName)
                          .toList(),
                      'totalPrice': state.totalPrice,
                    },
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
