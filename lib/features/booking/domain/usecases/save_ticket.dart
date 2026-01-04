import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/booking/domain/entities/ticket.dart';
import 'package:galaxymob/features/booking/domain/repositories/ticket_service.dart';

/// UseCase for saving a ticket locally
class SaveTicket implements UseCase<void, TicketParams> {
  final TicketService ticketService;

  SaveTicket(this.ticketService);

  @override
  Future<Either<Failure, void>> call(TicketParams params) async {
    return await ticketService.saveTicket(params.ticket);
  }
}

/// Parameters for ticket
class TicketParams extends Equatable {
  final Ticket ticket;

  const TicketParams({required this.ticket});

  @override
  List<Object?> get props => [ticket];
}
