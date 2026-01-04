import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/core/di/injection.dart';
import 'package:galaxymob/core/widgets/widgets.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';
import 'package:galaxymob/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/booking_event.dart';
import 'package:galaxymob/features/booking/presentation/bloc/booking_state.dart';
import 'package:galaxymob/features/booking/presentation/widgets/bookings/booking_card.dart';

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
          return BookingCard(
            booking: booking,
            isActive: isActive,
            onCancel: () => _showCancelDialog(context, booking),
            onViewTicket: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('View ticket - Coming soon!'),
                ),
              );
            },
          );
        },
      ),
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
            child: const Text('No, Keep it'),
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
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}
