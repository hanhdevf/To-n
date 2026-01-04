import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/booking/domain/entities/seat.dart';

/// Repository interface for seat operations
abstract class SeatRepository {
  /// Get seat layout for a specific showtime
  Future<Either<Failure, List<List<Seat>>>> getSeatLayout({
    required String showtimeId,
    required double basePrice,
  });
}
