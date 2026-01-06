import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/booking/domain/entities/seat.dart';
import 'package:galaxymob/features/booking/domain/entities/seat.dart' as entity;
import 'package:galaxymob/features/booking/domain/repositories/seat_repository.dart';
import 'package:galaxymob/features/cinema/data/datasources/cinema_firestore_data_source.dart';

/// Firestore implementation of SeatRepository
class SeatFirestoreRepositoryImpl implements SeatRepository {
  final CinemaFirestoreDataSource cinemaDataSource;

  SeatFirestoreRepositoryImpl({required this.cinemaDataSource});

  @override
  Future<Either<Failure, List<List<Seat>>>> getSeatLayout({
    required String showtimeId,
    required double basePrice,
  }) async {
    try {
      print('🔍 [DEBUG] Fetching showtime: $showtimeId');

      // Fetch showtime to get REAL-TIME booked seats and price
      final showtime = await cinemaDataSource.getShowtime(showtimeId);

      // Use the CURRENT price from Firestore, not the passed parameter
      final currentPrice = showtime.price;

      print('💰 [DEBUG] Firestore price: $currentPrice (passed: $basePrice)');
      print(
          '📍 [DEBUG] Cinema: ${showtime.cinemaId}, Movie: ${showtime.movieId}');

      // Generate seat layout (8 rows A-H)
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
    entity.SeatType type = entity.SeatType.regular;
    double price = basePrice;

    // VIP rows (D, E, F)
    if (rowName == 'D' || rowName == 'E' || rowName == 'F') {
      type = entity.SeatType.vip;
      price = basePrice * 1.5;
    }

    // Couple seats in back rows (G, H)
    if (rowName == 'G' || rowName == 'H') {
      final isLeftSide = seatNumber <= (totalSeatsInRow ~/ 2);
      if (isLeftSide && seatNumber >= (totalSeatsInRow ~/ 2) - 1) {
        type = entity.SeatType.couple;
        price = basePrice * 2.0;
      } else if (!isLeftSide && seatNumber >= totalSeatsInRow - 1) {
        type = entity.SeatType.couple;
        price = basePrice * 2.0;
      }
    }

    final seatId = '$showtimeId-$rowName$seatNumber';
    final status = bookedSeats.contains(seatId)
        ? entity.SeatStatus.booked
        : entity.SeatStatus.available;

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
