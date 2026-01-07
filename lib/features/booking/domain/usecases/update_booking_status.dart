import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';
import 'package:galaxymob/features/booking/domain/repositories/booking_repository.dart';

/// UseCase for updating a booking's status
class UpdateBookingStatus implements UseCase<void, UpdateBookingStatusParams> {
  final BookingRepository repository;

  UpdateBookingStatus(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateBookingStatusParams params) async {
    return await repository.updateBookingStatus(
      params.bookingId,
      params.status,
    );
  }
}

/// Parameters for updating booking status
class UpdateBookingStatusParams extends Equatable {
  final String bookingId;
  final BookingStatus status;

  const UpdateBookingStatusParams({
    required this.bookingId,
    required this.status,
  });

  @override
  List<Object?> get props => [bookingId, status];
}
