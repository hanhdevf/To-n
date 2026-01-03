import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/booking/domain/entities/ticket.dart';
import 'package:galaxymob/features/booking/presentation/bloc/ticket_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/ticket_event.dart';
import 'package:galaxymob/features/booking/presentation/bloc/ticket_state.dart';

/// My Tickets page showing all user's booked tickets
class MyTicketsPage extends StatefulWidget {
  const MyTicketsPage({super.key});

  @override
  State<MyTicketsPage> createState() => _MyTicketsPageState();
}

class _MyTicketsPageState extends State<MyTicketsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load tickets
    context.read<TicketBloc>().add(const LoadTicketsEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabBar(),
            Expanded(
              child: BlocBuilder<TicketBloc, TicketState>(
                builder: (context, state) {
                  if (state is TicketsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TicketsLoaded) {
                    return _buildTicketTabs(state);
                  } else if (state is TicketError) {
                    return _buildError(state.message);
                  }
                  return _buildEmpty();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(AppDimens.spacing16),
      child: Row(
        children: [
          Icon(Icons.confirmation_number, color: AppColors.primary, size: 32),
          SizedBox(width: AppDimens.spacing12),
          Text('My Tickets', style: AppTextStyles.h2),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: AppDimens.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
      ),
      child: TabBar(
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        ),
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.button,
        tabs: const [
          Tab(text: 'Upcoming'),
          Tab(text: 'Past'),
        ],
      ),
    );
  }

  Widget _buildTicketTabs(TicketsLoaded state) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildTicketList(state.upcomingTickets,
            isEmpty: state.upcomingTickets.isEmpty),
        _buildTicketList(state.pastTickets,
            isPast: true, isEmpty: state.pastTickets.isEmpty),
      ],
    );
  }

  Widget _buildTicketList(List<Ticket> tickets,
      {bool isPast = false, bool isEmpty = false}) {
    if (isEmpty) {
      return _buildEmpty(isPast: isPast);
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<TicketBloc>().add(const RefreshTicketsEvent());
      },
      child: ListView.builder(
        padding: EdgeInsets.all(AppDimens.spacing16),
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          return _buildTicketCard(tickets[index], isPast: isPast);
        },
      ),
    );
  }

  Widget _buildTicketCard(Ticket ticket, {bool isPast = false}) {
    final formatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    final dateFormat = DateFormat('EEE, MMM d • HH:mm');

    return Container(
      margin: EdgeInsets.only(bottom: AppDimens.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        border: Border.all(
          color: isPast
              ? Colors.white12
              : AppColors.primary.withValues(alpha: 0.3),
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
          onTap: () {
            // Navigate to ticket detail
            // context.pushNamed('ticketDetail', extra: ticket);
          },
          borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
          child: Padding(
            padding: EdgeInsets.all(AppDimens.spacing16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Movie title and status
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
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'VALID',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (isPast)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'USED',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: AppDimens.spacing12),

                // Cinema and showtime
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

                // Booking ID and price
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

  Widget _buildEmpty({bool isPast = false}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isPast ? Icons.history : Icons.confirmation_number_outlined,
            size: 80,
            color: AppColors.textSecondary.withValues(alpha: 0.3),
          ),
          SizedBox(height: AppDimens.spacing24),
          Text(
            isPast ? 'No past tickets' : 'No upcoming tickets',
            style: AppTextStyles.h3.copyWith(color: AppColors.textSecondary),
          ),
          SizedBox(height: AppDimens.spacing8),
          Text(
            isPast
                ? 'Your watched movies will appear here'
                : 'Book your first movie ticket!',
            style: AppTextStyles.body2,
            textAlign: TextAlign.center,
          ),
          if (!isPast) ...[
            SizedBox(height: AppDimens.spacing24),
            ElevatedButton.icon(
              onPressed: () {
                context.go('/home');
              },
              icon: Icon(Icons.movie),
              label: Text('Browse Movies'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimens.spacing24,
                  vertical: AppDimens.spacing12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          SizedBox(height: AppDimens.spacing16),
          Text('Error loading tickets', style: AppTextStyles.h3),
          SizedBox(height: AppDimens.spacing8),
          Text(message, style: AppTextStyles.body2),
          SizedBox(height: AppDimens.spacing24),
          ElevatedButton(
            onPressed: () {
              context.read<TicketBloc>().add(const LoadTicketsEvent());
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
}
