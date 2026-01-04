import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/booking/domain/entities/ticket.dart';
import 'package:galaxymob/features/booking/presentation/bloc/ticket_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/ticket_event.dart';
import 'package:galaxymob/features/booking/presentation/bloc/ticket_state.dart';
import 'package:galaxymob/features/booking/presentation/widgets/tickets/ticket_card.dart';
import 'package:galaxymob/features/booking/presentation/widgets/tickets/tickets_empty.dart';
import 'package:galaxymob/features/booking/presentation/widgets/tickets/tickets_error.dart';

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
                    return TicketsError(
                      message: state.message,
                      onRetry: () =>
                          context.read<TicketBloc>().add(const LoadTicketsEvent()),
                    );
                  }
                  return const TicketsEmpty();
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
          const Icon(Icons.confirmation_number,
              color: AppColors.primary, size: 32),
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
        _buildTicketList(state.upcomingTickets, isEmpty: state.upcomingTickets.isEmpty),
        _buildTicketList(state.pastTickets,
            isPast: true, isEmpty: state.pastTickets.isEmpty),
      ],
    );
  }

  Widget _buildTicketList(List<Ticket> tickets,
      {bool isPast = false, bool isEmpty = false}) {
    if (isEmpty) {
      return TicketsEmpty(isPast: isPast);
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<TicketBloc>().add(const RefreshTicketsEvent());
      },
      child: ListView.builder(
        padding: EdgeInsets.all(AppDimens.spacing16),
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          return TicketCard(
            ticket: tickets[index],
            isPast: isPast,
            onTap: () => context.pushNamed('ticketDetail', extra: tickets[index]),
          );
        },
      ),
    );
  }
}
