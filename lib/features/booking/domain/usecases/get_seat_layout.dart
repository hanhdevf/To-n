import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/booking/domain/entities/seat.dart';
import 'package:galaxymob/features/booking/domain/repositories/seat_repository.dart';

/// UseCase for getting seat layout for a showtime
class GetSeatLayout implements UseCase<List<List<Seat>>, SeatLayoutParams> {
  final SeatRepository repository;

  GetSeatLayout(this.repository);

  @override
  Future<Either<Failure, List<List<Seat>>>> call(
      SeatLayoutParams params) async {
    return await repository.getSeatLayout(
      showtimeId: params.showtimeId,
      basePrice: params.basePrice,
    );
  }
}

/// Parameters for seat layout
class SeatLayoutParams extends Equatable {
  final String showtimeId;
  final double basePrice;

  const SeatLayoutParams({
    required this.showtimeId,
    required this.basePrice,
  });

  @override
  List<Object?> get props => [showtimeId, basePrice];
}
