import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/booking/presentation/bloc/seat_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/seat_state.dart';
import 'package:galaxymob/features/booking/presentation/widgets/seat_selection/seat_bottom_bar.dart';
import 'package:galaxymob/features/booking/presentation/widgets/seat_selection/seat_grid.dart';
import 'package:galaxymob/features/booking/presentation/widgets/seat_selection/seat_legend.dart';
import 'package:galaxymob/features/booking/presentation/widgets/seat_selection/seat_movie_info.dart';

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
          SeatMovieInfo(
            movieTitle: movieTitle,
            cinemaName: cinemaName,
            showtime: showtime,
          ),
          _buildScreenIndicator(),
          const SeatLegend(),
          Expanded(
            child: BlocBuilder<SeatBloc, SeatState>(
              builder: (context, state) {
                if (state is SeatLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SeatLayoutLoaded) {
                  return SeatGrid(state: state);
                } else if (state is SeatError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BlocBuilder<SeatBloc, SeatState>(
        builder: (context, state) {
          if (state is! SeatLayoutLoaded || state.selectedCount == 0) {
            return const SizedBox.shrink();
          }
          return SeatBottomBar(
            state: state,
            movieTitle: movieTitle,
            cinemaName: cinemaName,
            showtime: showtime,
          );
        },
      ),
    );
  }

  Widget _buildScreenIndicator() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.3),
            AppColors.primary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
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
}
