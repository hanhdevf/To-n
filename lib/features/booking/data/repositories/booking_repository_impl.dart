import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/booking/data/datasources/mock_booking_data_source.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';
import 'package:galaxymob/features/booking/domain/repositories/booking_repository.dart';

/// Implementation of BookingRepository
class BookingRepositoryImpl implements BookingRepository {
  final MockBookingDataSource dataSource;

  BookingRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<Booking>>> getUserBookings(String userId) async {
    try {
      final bookings = await dataSource.getUserBookings(userId);
      return Right(bookings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelBooking(String bookingId) async {
    try {
      final success = await dataSource.cancelBooking(bookingId);
      if (success) {
        return const Right(null);
      } else {
        return const Left(ServerFailure('Failed to cancel booking'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Booking>> createBooking(Booking booking) async {
    try {
      final createdBooking = await dataSource.saveBooking(booking);
      return Right(createdBooking);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
