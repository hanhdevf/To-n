import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/core/di/injection.dart';
import 'package:galaxymob/core/widgets/widgets.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';
import 'package:galaxymob/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/booking_event.dart';
import 'package:galaxymob/features/booking/presentation/bloc/booking_state.dart';

/// My Bookings page showing active and past bookings
class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<BookingBloc>()..add(const LoadBookingsEvent('current-user')),
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Bookings', style: AppTextStyles.h3),
          backgroundColor: AppColors.background,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: AppTextStyles.body1Medium,
            tabs: const [
              Tab(text: 'Active'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: BlocBuilder<BookingBloc, BookingState>(
          builder: (context, state) {
            if (state is BookingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BookingsLoaded) {
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildBookingsList(
                    context,
                    state.activeBookings,
                    isActive: true,
                  ),
                  _buildBookingsList(
                    context,
                    state.pastBookings,
                    isActive: false,
                  ),
                ],
              );
            } else if (state is BookingError) {
              return ErrorStateWidget(
                title: 'Failed to load bookings',
                message: state.message,
                onRetry: () {
                  context
                      .read<BookingBloc>()
                      .add(const RefreshBookingsEvent('current-user'));
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildBookingsList(
    BuildContext context,
    List<Booking> bookings, {
    required bool isActive,
  }) {
    if (bookings.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.receipt_long,
        title: isActive ? 'No Active Bookings' : 'No Past Bookings',
        message: isActive
            ? 'You don\'t have any upcoming movies'
            : 'Your booking history is empty',
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        context
            .read<BookingBloc>()
            .add(const RefreshBookingsEvent('current-user'));
      },
      child: ListView.separated(
        padding: EdgeInsets.all(AppDimens.spacing16),
        itemCount: bookings.length,
        separatorBuilder: (context, index) =>
            SizedBox(height: AppDimens.spacing16),
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return _buildBookingCard(context, booking, isActive: isActive);
        },
      ),
    );
  }

  Widget _buildBookingCard(
    BuildContext context,
    Booking booking, {
    required bool isActive,
  }) {
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
          // Header with movie title and status
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

          // Booking details
          Padding(
            padding: EdgeInsets.all(AppDimens.spacing16),
            child: Column(
              children: [
                _buildDetailRow(
                  Icons.location_on,
                  'Cinema',
                  booking.cinemaName,
                ),
                SizedBox(height: AppDimens.spacing12),
                _buildDetailRow(
                  Icons.calendar_today,
                  'Date & Time',
                  '${dateFormatter.format(booking.showtime)} • ${timeFormatter.format(booking.showtime)}',
                ),
                SizedBox(height: AppDimens.spacing12),
                _buildDetailRow(
                  Icons.event_seat,
                  'Seats',
                  booking.formattedSeats,
                ),
                SizedBox(height: AppDimens.spacing12),
                _buildDetailRow(
                  Icons.payment,
                  'Total',
                  priceFormatter.format(booking.totalPrice),
                  valueColor: AppColors.primary,
                  valueWeight: FontWeight.bold,
                ),
              ],
            ),
          ),

          // Action buttons (only for active bookings)
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
                      onPressed: () => _showCancelDialog(context, booking),
                      icon: Icon(Icons.close, size: 18),
                      label: Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(color: AppColors.error),
                        padding: EdgeInsets.symmetric(
                          vertical: AppDimens.spacing12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppDimens.spacing8),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Navigate to ticket detail
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('View ticket - Coming soon!'),
                          ),
                        );
                      },
                      icon: Icon(Icons.qr_code, size: 18),
                      label: Text('View Ticket'),
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

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
    FontWeight? valueWeight,
  }) {
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

  void _showCancelDialog(BuildContext context, Booking booking) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Cancel Booking?', style: AppTextStyles.h3),
        content: Text(
          'Are you sure you want to cancel this booking? This action cannot be undone.',
          style: AppTextStyles.body1,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('No, Keep it'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<BookingBloc>().add(
                    CancelBookingEvent(booking.id),
                  );
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Booking cancelled successfully'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}
