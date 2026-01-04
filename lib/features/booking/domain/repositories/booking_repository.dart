import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';

/// Repository interface for booking operations
abstract class BookingRepository {
  /// Get all bookings for a specific user
  Future<Either<Failure, List<Booking>>> getUserBookings(String userId);

  /// Cancel a booking
  Future<Either<Failure, void>> cancelBooking(String bookingId);

  /// Create a new booking
  Future<Either<Failure, Booking>> createBooking(Booking booking);
}
