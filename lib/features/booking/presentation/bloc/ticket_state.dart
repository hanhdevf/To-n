import 'package:equatable/equatable.dart';
import 'package:galaxymob/features/booking/domain/entities/ticket.dart';

/// Ticket States
abstract class TicketState extends Equatable {
  const TicketState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class TicketInitial extends TicketState {
  const TicketInitial();
}

/// Loading tickets
class TicketsLoading extends TicketState {
  const TicketsLoading();
}

/// Tickets loaded successfully
class TicketsLoaded extends TicketState {
  final List<Ticket> tickets;
  final List<Ticket> upcomingTickets;
  final List<Ticket> pastTickets;

  const TicketsLoaded({
    required this.tickets,
    required this.upcomingTickets,
    required this.pastTickets,
  });

  @override
  List<Object?> get props => [tickets, upcomingTickets, pastTickets];
}

/// Single ticket generated
class TicketGenerated extends TicketState {
  final Ticket ticket;

  const TicketGenerated(this.ticket);

  @override
  List<Object?> get props => [ticket];
}

/// Ticket operation error
class TicketError extends TicketState {
  final String message;

  const TicketError(this.message);

  @override
  List<Object?> get props => [message];
}
