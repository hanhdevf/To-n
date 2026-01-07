import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/booking/data/datasources/booking_firestore_data_source.dart';
import 'package:galaxymob/features/booking/data/models/booking_model.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';
import 'package:galaxymob/features/booking/domain/repositories/booking_repository.dart';
import 'package:galaxymob/features/cinema/data/datasources/cinema_firestore_data_source.dart';

/// Firestore implementation of BookingRepository
class BookingFirestoreRepositoryImpl implements BookingRepository {
  final BookingFirestoreDataSource bookingDataSource;
  final CinemaFirestoreDataSource cinemaDataSource;
  final FirebaseAuth auth;

  BookingFirestoreRepositoryImpl({
    required this.bookingDataSource,
    required this.cinemaDataSource,
    required this.auth,
  });

  @override
  Future<Either<Failure, List<Booking>>> getUserBookings(String userId) async {
    try {
      final bookingModels = await bookingDataSource.getUserBookings(userId);
      final bookings = bookingModels.map((model) => model.toEntity()).toList();
      return Right(bookings);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Booking>> createBooking(Booking booking) async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return Left(ServerFailure('User not authenticated'));
      }

      // Extract seat IDs
      final seatIds = booking.selectedSeats.map((s) => s.id).toList();

      // Create booking model
      final bookingModel = BookingModel.fromEntity(booking, user.uid);

      // Create booking with transaction
      final bookingId = await bookingDataSource.createBooking(
        booking: bookingModel,
        seatIds: seatIds,
      );

      // Fetch created booking
      final createdBookingModel = await bookingDataSource.getBooking(bookingId);
      return Right(createdBookingModel.toEntity());
    } catch (e) {
      if (e.toString().contains('already booked')) {
        return Left(ServerFailure('Selected seats are no longer available'));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelBooking(String bookingId) async {
    try {
      await bookingDataSource.cancelBooking(bookingId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateBookingStatus(
    String bookingId,
    BookingStatus status,
  ) async {
    try {
      await bookingDataSource.updateBookingStatus(bookingId, status);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
