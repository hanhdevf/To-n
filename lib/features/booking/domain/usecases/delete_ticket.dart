import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/booking/domain/repositories/ticket_service.dart';

/// UseCase for deleting a ticket
class DeleteTicket implements UseCase<void, TicketIdParams> {
  final TicketService ticketService;

  DeleteTicket(this.ticketService);

  @override
  Future<Either<Failure, void>> call(TicketIdParams params) async {
    return await ticketService.deleteTicket(params.ticketId);
  }
}

/// Parameters for ticket ID
class TicketIdParams extends Equatable {
  final String ticketId;

  const TicketIdParams({required this.ticketId});

  @override
  List<Object?> get props => [ticketId];
}
