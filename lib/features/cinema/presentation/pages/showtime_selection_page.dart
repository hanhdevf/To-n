import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/core/widgets/widgets.dart';
import 'package:galaxymob/features/cinema/presentation/bloc/cinema_bloc.dart';
import 'package:galaxymob/features/cinema/presentation/bloc/cinema_event.dart';
import 'package:galaxymob/features/cinema/presentation/bloc/cinema_state.dart';
import 'package:galaxymob/features/cinema/domain/entities/cinema.dart';
import 'package:galaxymob/features/cinema/domain/entities/showtime.dart';

/// Showtime selection page for choosing cinema and time
class ShowtimeSelectionPage extends StatefulWidget {
  final int movieId;
  final String movieTitle;

  const ShowtimeSelectionPage({
    super.key,
    required this.movieId,
    required this.movieTitle,
  });

  @override
  State<ShowtimeSelectionPage> createState() => _ShowtimeSelectionPageState();
}

class _ShowtimeSelectionPageState extends State<ShowtimeSelectionPage> {
  DateTime selectedDate = DateTime.now();
  final List<DateTime> availableDates = [];

  @override
  void initState() {
    super.initState();
    _generateDates();
    _loadShowtimes();
  }

  void _generateDates() {
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      availableDates.add(now.add(Duration(days: i)));
    }
  }

  void _loadShowtimes() {
    context.read<CinemaBloc>().add(
          LoadShowtimesEvent(
            movieId: widget.movieId,
            date: selectedDate,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Showtime',
          style: AppTextStyles.h3,
        ),
        backgroundColor: AppColors.background,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie title
          Container(
            padding: EdgeInsets.all(AppDimens.spacing16),
            color: AppColors.surface,
            child: Row(
              children: [
                Icon(Icons.movie, color: AppColors.primary),
                SizedBox(width: AppDimens.spacing12),
                Expanded(
                  child: Text(
                    widget.movieTitle,
                    style: AppTextStyles.h3,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Date selector
          _buildDateSelector(),

          // Showtimes list
          Expanded(
            child: BlocBuilder<CinemaBloc, CinemaState>(
              builder: (context, state) {
                if (state is CinemaLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ShowtimesLoaded) {
                  return _buildShowtimesList(state);
                } else if (state is CinemaError) {
                  return ErrorStateWidget(
                    title: 'Failed to load showtimes',
                    message: state.message,
                    onRetry: _loadShowtimes,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      height: 120, // Increased from 100 to 120 (8pt grid: 15×8)
      padding: EdgeInsets.symmetric(vertical: AppDimens.spacing12),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppDimens.spacing16),
        itemCount: availableDates.length,
        separatorBuilder: (context, index) =>
            SizedBox(width: AppDimens.spacing12),
        itemBuilder: (context, index) {
          final date = availableDates[index];
          final isSelected = DateUtils.isSameDay(date, selectedDate);

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedDate = date;
              });
              _loadShowtimes();
            },
            child: Container(
              width: 80, // Increased width for better proportions
              padding: EdgeInsets.symmetric(
                horizontal: AppDimens.spacing8,
                vertical: AppDimens.spacing12,
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('EEE').format(date).toUpperCase(),
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textSecondary,
                      fontSize: 10, // Explicit small size
                    ),
                  ),
                  SizedBox(height: AppDimens.spacing4),
                  Text(
                    DateFormat('dd').format(date),
                    style: AppTextStyles.h3.copyWith(
                      // Changed from h2 to h3
                      color:
                          isSelected ? AppColors.white : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppDimens.spacing4),
                  Text(
                    DateFormat('MMM').format(date).toUpperCase(),
                    style: AppTextStyles.caption.copyWith(
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textSecondary,
                      fontSize: 10, // Explicit small size
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShowtimesList(ShowtimesLoaded state) {
    if (state.cinemas.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.theaters,
        title: 'No Cinemas',
        message: 'No cinemas available',
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(AppDimens.spacing16),
      itemCount: state.cinemas.length,
      separatorBuilder: (context, index) =>
          SizedBox(height: AppDimens.spacing16),
      itemBuilder: (context, index) {
        final cinema = state.cinemas[index];
        final showtimes = state.showtimesByCinema[cinema.id] ?? [];

        return _CinemaExpandableCard(
          cinema: cinema,
          showtimes: showtimes,
          movieTitle: widget.movieTitle,
        );
      },
    );
  }
}

class _CinemaExpandableCard extends StatefulWidget {
  final Cinema cinema;
  final List<Showtime> showtimes;
  final String movieTitle;

  const _CinemaExpandableCard({
    required this.cinema,
    required this.showtimes,
    required this.movieTitle,
  });

  @override
  State<_CinemaExpandableCard> createState() => _CinemaExpandableCardState();
}

class _CinemaExpandableCardState extends State<_CinemaExpandableCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header (Clickable)
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppDimens.radiusMedium),
              topRight: Radius.circular(AppDimens.radiusMedium),
              bottomLeft: _isExpanded
                  ? Radius.zero
                  : Radius.circular(AppDimens.radiusMedium),
              bottomRight: _isExpanded
                  ? Radius.zero
                  : Radius.circular(AppDimens.radiusMedium),
            ),
            child: Padding(
              padding: EdgeInsets.all(AppDimens.spacing16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Cinema name
                        Text(
                          widget.cinema.name,
                          style: AppTextStyles.h3,
                        ),
                        SizedBox(height: AppDimens.spacing4),

                        // Address
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(width: AppDimens.spacing4),
                            Expanded(
                              child: Text(
                                widget.cinema.address,
                                style: AppTextStyles.caption,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),

          // Collapsible Body
          AnimatedCrossFade(
            firstChild: Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                AppDimens.spacing16,
                0,
                AppDimens.spacing16,
                AppDimens.spacing16,
              ),
              child: Wrap(
                spacing: AppDimens.spacing8,
                runSpacing: AppDimens.spacing8,
                children: widget.showtimes.map<Widget>((showtime) {
                  return _ShowtimeChip(
                    showtime: showtime,
                    movieTitle: widget.movieTitle,
                    cinemaName: widget.cinema.name,
                  );
                }).toList(),
              ),
            ),
            secondChild: const SizedBox(width: double.infinity),
            crossFadeState: _isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}

class _ShowtimeChip extends StatelessWidget {
  final Showtime showtime;
  final String movieTitle;
  final String cinemaName;

  const _ShowtimeChip({
    required this.showtime,
    required this.movieTitle,
    required this.cinemaName,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    return InkWell(
      onTap: () {
        // Navigate to seat selection
        context.push(
          '/booking/seats',
          extra: {
            'showtimeId': showtime.id,
            'movieTitle': movieTitle,
            'cinemaName': cinemaName,
            'showtime': showtime.formattedTime,
            'basePrice': showtime.price,
          },
        );
      },
      borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.spacing12,
          vertical: AppDimens.spacing8,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
        ),
        child: Column(
          children: [
            Text(
              showtime.formattedTime,
              style: AppTextStyles.body1Medium.copyWith(
                color: AppColors.primary,
              ),
            ),
            Text(
              formatter.format(showtime.price),
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}
