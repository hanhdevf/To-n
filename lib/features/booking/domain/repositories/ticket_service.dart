import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/booking/domain/entities/ticket.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';

/// Ticket service interface for managing tickets
abstract class TicketService {
  /// Generate a ticket from a booking
  Future<Either<Failure, Ticket>> generateTicket(Booking booking);

  /// Save ticket locally
  Future<Either<Failure, void>> saveTicket(Ticket ticket);

  /// Get all user tickets
  Future<Either<Failure, List<Ticket>>> getUserTickets();

  /// Get ticket by ID
  Future<Either<Failure, Ticket>> getTicketById(String ticketId);

  /// Delete ticket
  Future<Either<Failure, void>> deleteTicket(String ticketId);
}
