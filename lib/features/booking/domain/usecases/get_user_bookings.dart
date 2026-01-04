import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';
import 'package:galaxymob/features/booking/domain/repositories/booking_repository.dart';

/// UseCase for getting user bookings
class GetUserBookings implements UseCase<List<Booking>, UserIdParams> {
  final BookingRepository repository;

  GetUserBookings(this.repository);

  @override
  Future<Either<Failure, List<Booking>>> call(UserIdParams params) async {
    return await repository.getUserBookings(params.userId);
  }
}

/// Parameters for user ID
class UserIdParams extends Equatable {
  final String userId;

  const UserIdParams({required this.userId});

  @override
  List<Object?> get props => [userId];
}
