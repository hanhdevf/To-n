import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';
import 'package:galaxymob/features/booking/domain/entities/ticket.dart';
import 'package:galaxymob/features/booking/domain/repositories/ticket_service.dart';

/// UseCase for generating a ticket from a booking
class GenerateTicket implements UseCase<Ticket, BookingParams> {
  final TicketService ticketService;

  GenerateTicket(this.ticketService);

  @override
  Future<Either<Failure, Ticket>> call(BookingParams params) async {
    return await ticketService.generateTicket(params.booking);
  }
}

/// Parameters for booking
class BookingParams extends Equatable {
  final Booking booking;

  const BookingParams({required this.booking});

  @override
  List<Object?> get props => [booking];
}
