import 'dart:math';
import 'package:galaxymob/features/booking/domain/entities/seat.dart';

/// Mock data source for seat layouts
class MockSeatDataSource {
  final Random _random = Random();

  /// Generate a realistic cinema seat layout (8 rows × 8-10 seats with center aisle)
  /// Layout:
  /// - Front rows (A, B): 4-4 (8 seats total)
  /// - Middle rows (C, D, E, F): 5-5 (10 seats total, VIP)
  /// - Back rows (G, H): 5-5 (10 seats total, with couple seats)
  List<List<Seat>> generateSeatLayout({
    required String showtimeId,
    required double basePrice,
  }) {
    final List<List<Seat>> seatLayout = [];
    final rows = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H'];

    for (int rowIndex = 0; rowIndex < rows.length; rowIndex++) {
      final rowSeats = <Seat>[];
      final rowName = rows[rowIndex];

      // Determine seats per side based on row
      int leftSeats, rightSeats;
      if (rowIndex < 2) {
        // Front rows: 4-4
        leftSeats = 4;
        rightSeats = 4;
      } else {
        // Middle and back rows: 5-5
        leftSeats = 5;
        rightSeats = 5;
      }

      int seatNumber = 1;

      // Left side seats
      for (int i = 0; i < leftSeats; i++) {
        rowSeats.add(_createSeat(
          showtimeId: showtimeId,
          rowName: rowName,
          rowIndex: rowIndex,
          seatNumber: seatNumber,
          totalSeatsInRow: leftSeats + rightSeats,
          basePrice: basePrice,
        ));
        seatNumber++;
      }

      // Center aisle (empty space - null seat for spacing)
      // We don't add null, just skip to create visual gap in UI

      // Right side seats
      for (int i = 0; i < rightSeats; i++) {
        rowSeats.add(_createSeat(
          showtimeId: showtimeId,
          rowName: rowName,
          rowIndex: rowIndex,
          seatNumber: seatNumber,
          totalSeatsInRow: leftSeats + rightSeats,
          basePrice: basePrice,
        ));
        seatNumber++;
      }

      seatLayout.add(rowSeats);
    }

    return seatLayout;
  }

  Seat _createSeat({
    required String showtimeId,
    required String rowName,
    required int rowIndex,
    required int seatNumber,
    required int totalSeatsInRow,
    required double basePrice,
  }) {
    SeatType type = SeatType.regular;
    double price = basePrice;

    // VIP rows (D, E, F - middle rows for best viewing)
    if (rowName == 'D' || rowName == 'E' || rowName == 'F') {
      type = SeatType.vip;
      price = basePrice * 1.5;
    }

    // Couple seats (last 2 seats on each side in back rows G, H)
    // Left side: seats 4-5 (if 5 seats) or 3-4 (if 4 seats)
    // Right side: last 2 seats
    if ((rowName == 'G' || rowName == 'H')) {
      final isLeftSide = seatNumber <= (totalSeatsInRow ~/ 2);
      final isRightSide = !isLeftSide;

      if (isLeftSide && seatNumber >= (totalSeatsInRow ~/ 2) - 1) {
        // Last 2 seats of left side
        type = SeatType.couple;
        price = basePrice * 2.0;
      } else if (isRightSide && seatNumber >= totalSeatsInRow - 1) {
        // Last 2 seats of right side
        type = SeatType.couple;
        price = basePrice * 2.0;
      }
    }

    // Random booked seats (reduced to 20% for more realistic availability)
    final status = _getRandomStatus();

    return Seat(
      id: '$showtimeId-$rowName$seatNumber',
      row: rowName,
      number: seatNumber,
      type: type,
      status: status,
      price: price,
    );
  }

  SeatStatus _getRandomStatus() {
    // Use proper random number generator
    // 20% chance of being booked (more realistic)
    final randomValue = _random.nextInt(100);
    if (randomValue < 20) {
      return SeatStatus.booked;
    }
    return SeatStatus.available;
  }
}
