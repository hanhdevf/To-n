import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/booking/domain/repositories/booking_repository.dart';

/// UseCase for canceling a booking
class CancelBooking implements UseCase<void, BookingIdParams> {
  final BookingRepository repository;

  CancelBooking(this.repository);

  @override
  Future<Either<Failure, void>> call(BookingIdParams params) async {
    return await repository.cancelBooking(params.bookingId);
  }
}

/// Parameters for booking ID
class BookingIdParams extends Equatable {
  final String bookingId;

  const BookingIdParams({required this.bookingId});

  @override
  List<Object?> get props => [bookingId];
}
