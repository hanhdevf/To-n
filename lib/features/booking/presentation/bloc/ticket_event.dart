import 'package:equatable/equatable.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';

/// Ticket Events
abstract class TicketEvent extends Equatable {
  const TicketEvent();

  @override
  List<Object?> get props => [];
}

/// Load all user tickets
class LoadTicketsEvent extends TicketEvent {
  const LoadTicketsEvent();
}

/// Generate ticket from booking
class GenerateTicketEvent extends TicketEvent {
  final Booking booking;

  const GenerateTicketEvent(this.booking);

  @override
  List<Object?> get props => [booking];
}

/// Delete a ticket
class DeleteTicketEvent extends TicketEvent {
  final String ticketId;

  const DeleteTicketEvent(this.ticketId);

  @override
  List<Object?> get props => [ticketId];
}

/// Generate ticket from booking
class GenerateTicketFromBookingEvent extends TicketEvent {
  final Booking booking;

  const GenerateTicketFromBookingEvent(this.booking);

  @override
  List<Object?> get props => [booking];
}

/// Refresh tickets
class RefreshTicketsEvent extends TicketEvent {
  const RefreshTicketsEvent();
}
