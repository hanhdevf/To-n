import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/booking/domain/entities/ticket.dart';
import 'package:galaxymob/features/booking/domain/repositories/ticket_service.dart';

/// UseCase for getting user tickets
class GetUserTickets implements UseCase<List<Ticket>, NoParams> {
  final TicketService ticketService;

  GetUserTickets(this.ticketService);

  @override
  Future<Either<Failure, List<Ticket>>> call(NoParams params) async {
    return await ticketService.getUserTickets();
  }
}
