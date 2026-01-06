import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/booking/data/datasources/booking_firestore_data_source.dart';
import 'package:galaxymob/features/booking/data/models/booking_model.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';
import 'package:galaxymob/features/booking/domain/entities/seat.dart';
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

  /// Get seat layout for a showtime (bonus method not in original interface)
  Future<Either<Failure, List<List<Seat>>>> getSeatLayout({
    required String showtimeId,
    required double basePrice,
  }) async {
    try {
      // Fetch showtime to get booked seats
      final showtime = await cinemaDataSource.getShowtime(showtimeId);

      // Generate seat layout (8 rows A-H, similar to mock)
      final List<List<Seat>> seatLayout = [];
      final rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

      for (int rowIndex = 0; rowIndex < rows.length; rowIndex++) {
        final rowSeats = <Seat>[];
        final rowName = rows[rowIndex];

        int leftSeats, rightSeats;
        if (rowIndex < 2) {
          leftSeats = 4;
          rightSeats = 4;
        } else {
          leftSeats = 5;
          rightSeats = 5;
        }

        int seatNumber = 1;

        // Use the realtime price from Firestore, not the cached/passed one
        final currentPrice = showtime.price;

        // Left side
        for (int i = 0; i < leftSeats; i++) {
          rowSeats.add(_createSeat(
            showtimeId: showtimeId,
            rowName: rowName,
            rowIndex: rowIndex,
            seatNumber: seatNumber,
            totalSeatsInRow: leftSeats + rightSeats,
            basePrice: currentPrice,
            bookedSeats: showtime.bookedSeats,
          ));
          seatNumber++;
        }

        // Right side
        for (int i = 0; i < rightSeats; i++) {
          rowSeats.add(_createSeat(
            showtimeId: showtimeId,
            rowName: rowName,
            rowIndex: rowIndex,
            seatNumber: seatNumber,
            totalSeatsInRow: leftSeats + rightSeats,
            basePrice: currentPrice,
            bookedSeats: showtime.bookedSeats,
          ));
          seatNumber++;
        }

        seatLayout.add(rowSeats);
      }

      return Right(seatLayout);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Seat _createSeat({
    required String showtimeId,
    required String rowName,
    required int rowIndex,
    required int seatNumber,
    required int totalSeatsInRow,
    required double basePrice,
    required List<String> bookedSeats,
  }) {
    SeatType type = SeatType.regular;
    double price = basePrice;

    // VIP rows
    if (rowName == 'D' || rowName == 'E' || rowName == 'F') {
      type = SeatType.vip;
      price = basePrice * 1.5;
    }

    // Couple seats in back rows
    if (rowName == 'G' || rowName == 'H') {
      final isLeftSide = seatNumber <= (totalSeatsInRow ~/ 2);
      if (isLeftSide && seatNumber >= (totalSeatsInRow ~/ 2) - 1) {
        type = SeatType.couple;
        price = basePrice * 2.0;
      } else if (!isLeftSide && seatNumber >= totalSeatsInRow - 1) {
        type = SeatType.couple;
        price = basePrice * 2.0;
      }
    }

    final seatId = '$showtimeId-$rowName$seatNumber';
    final status =
        bookedSeats.contains(seatId) ? SeatStatus.booked : SeatStatus.available;

    return Seat(
      id: seatId,
      row: rowName,
      number: seatNumber,
      type: type,
      status: status,
      price: price,
    );
  }
}
