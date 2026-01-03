import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxymob/features/booking/domain/repositories/ticket_service.dart';
import 'package:galaxymob/features/booking/presentation/bloc/ticket_event.dart';
import 'package:galaxymob/features/booking/presentation/bloc/ticket_state.dart';

/// BLoC for managing user tickets
class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final TicketService ticketService;

  TicketBloc({required this.ticketService}) : super(const TicketInitial()) {
    on<LoadTicketsEvent>(_onLoadTickets);
    on<GenerateTicketEvent>(_onGenerateTicket);
    on<DeleteTicketEvent>(_onDeleteTicket);
    on<RefreshTicketsEvent>(_onRefreshTickets);
  }

  Future<void> _onLoadTickets(
    LoadTicketsEvent event,
    Emitter<TicketState> emit,
  ) async {
    emit(const TicketsLoading());

    final result = await ticketService.getUserTickets();

    result.fold(
      (failure) => emit(TicketError(failure.message)),
      (tickets) {
        final now = DateTime.now();
        final upcomingTickets =
            tickets.where((t) => t.booking.showtime.isAfter(now)).toList();
        final pastTickets =
            tickets.where((t) => t.booking.showtime.isBefore(now)).toList();

        emit(TicketsLoaded(
          tickets: tickets,
          upcomingTickets: upcomingTickets,
          pastTickets: pastTickets,
        ));
      },
    );
  }

  Future<void> _onGenerateTicket(
    GenerateTicketEvent event,
    Emitter<TicketState> emit,
  ) async {
    emit(const TicketsLoading());

    // Generate ticket
    final ticketResult = await ticketService.generateTicket(event.booking);

    await ticketResult.fold(
      (failure) async => emit(TicketError(failure.message)),
      (ticket) async {
        // Save ticket
        final saveResult = await ticketService.saveTicket(ticket);

        saveResult.fold(
          (failure) => emit(TicketError(failure.message)),
          (_) => emit(TicketGenerated(ticket)),
        );
      },
    );
  }

  Future<void> _onDeleteTicket(
    DeleteTicketEvent event,
    Emitter<TicketState> emit,
  ) async {
    final result = await ticketService.deleteTicket(event.ticketId);

    result.fold(
      (failure) => emit(TicketError(failure.message)),
      (_) => add(const RefreshTicketsEvent()), // Reload tickets
    );
  }

  Future<void> _onRefreshTickets(
    RefreshTicketsEvent event,
    Emitter<TicketState> emit,
  ) async {
    add(const LoadTicketsEvent());
  }
}
