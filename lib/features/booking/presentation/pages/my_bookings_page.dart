import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/core/di/injection.dart';
import 'package:galaxymob/core/widgets/widgets.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';
import 'package:galaxymob/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/booking_event.dart';
import 'package:galaxymob/features/booking/presentation/bloc/booking_state.dart';
import 'package:galaxymob/features/booking/presentation/bloc/ticket_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/ticket_event.dart';
import 'package:galaxymob/features/booking/presentation/bloc/ticket_state.dart';
import 'package:galaxymob/features/booking/presentation/widgets/bookings/booking_card.dart';
import 'package:galaxymob/features/booking/presentation/widgets/bookings/booking_list_shimmer.dart';

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
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? 'guest';

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<BookingBloc>()..add(LoadBookingsEvent(userId)),
        ),
        BlocProvider(
          create: (context) =>
              getIt<TicketBloc>()..add(const LoadTicketsEvent()),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<BookingBloc, BookingState>(
            listener: (context, state) {
              if (state is BookingCancelled) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking cancelled successfully'),
                    backgroundColor: AppColors.success,
                    duration: Duration(seconds: 2),
                  ),
                );
              } else if (state is BookingError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
          ),
          BlocListener<TicketBloc, TicketState>(
            listener: (context, state) {
              if (state is TicketGenerated) {
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ticket generated successfully!'),
                    backgroundColor: AppColors.success,
                    duration: Duration(seconds: 2),
                  ),
                );
              } else if (state is TicketError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                    duration: const Duration(seconds: 3),
                  ),
                );
              }
            },
          ),
        ],
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
                return const BookingListShimmer();
              } else if (state is BookingsLoaded) {
                return TabBarView(
                  controller: _tabController,
                  children: [
                    _buildBookingsList(
                      context,
                      state.activeBookings,
                      userId: userId,
                      isActive: true,
                    ),
                    _buildBookingsList(
                      context,
                      state.pastBookings,
                      userId: userId,
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
                        .add(RefreshBookingsEvent(userId));
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBookingsList(
    BuildContext context,
    List<Booking> bookings, {
    required String userId,
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
        context.read<BookingBloc>().add(RefreshBookingsEvent(userId));
      },
      child: ListView.separated(
        padding: EdgeInsets.all(AppDimens.spacing16),
        itemCount: bookings.length,
        separatorBuilder: (context, index) =>
            SizedBox(height: AppDimens.spacing16),
        itemBuilder: (context, index) {
          final booking = bookings[index];

          // Use BlocBuilder to check if ticket exists for this booking
          return BlocBuilder<TicketBloc, TicketState>(
            builder: (context, ticketState) {
              bool hasTicket = false;

              // Check if ticket already generated
              if (ticketState is TicketsLoaded) {
                hasTicket = ticketState.tickets.any(
                  (ticket) => ticket.booking.id == booking.id,
                );
              }

              return BookingCard(
                booking: booking,
                isActive: isActive,
                hasTicket: hasTicket,
                onCancel: () => _showCancelDialog(context, booking),
                onGenerateTicket: () {
                  // Generate ticket - status will be updated automatically via BlocListener
                  context.read<TicketBloc>().add(
                        GenerateTicketFromBookingEvent(booking),
                      );
                },
                onViewTicket: () {
                  // Navigate to ticket detail if ticket exists
                  if (ticketState is TicketsLoaded) {
                    try {
                      final ticket = ticketState.tickets.firstWhere(
                        (t) => t.booking.id == booking.id,
                      );
                      context.pushNamed('ticketDetail', extra: ticket);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ticket not found')),
                      );
                    }
                  }
                },
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
