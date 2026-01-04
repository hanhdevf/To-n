import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/booking/domain/entities/seat.dart';
import 'package:galaxymob/features/booking/presentation/bloc/seat_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/seat_event.dart';
import 'package:galaxymob/features/booking/presentation/bloc/seat_state.dart';

class SeatGrid extends StatelessWidget {
  final SeatLayoutLoaded state;

  const SeatGrid({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimens.spacing16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: state.seatLayout.asMap().entries.map((entry) {
            final rowIndex = entry.key;
            final rowSeats = entry.value;
            final splitPoint = rowIndex < 2 ? 4 : 5;
            final leftSeats = rowSeats.take(splitPoint).toList();
            final rightSeats = rowSeats.skip(splitPoint).toList();
            final rowLetter = rowSeats.isNotEmpty ? rowSeats.first.row : '';

            return Padding(
              padding: EdgeInsets.only(bottom: AppDimens.spacing8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  ...leftSeats.map((seat) => _SeatTile(seat: seat)),
                  SizedBox(width: AppDimens.spacing24),
                  ...rightSeats.map((seat) => _SeatTile(seat: seat)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _SeatTile extends StatelessWidget {
  final Seat seat;

  const _SeatTile({required this.seat});

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.all(2),
      child: GestureDetector(
        key: ValueKey(seat.id),
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
}
