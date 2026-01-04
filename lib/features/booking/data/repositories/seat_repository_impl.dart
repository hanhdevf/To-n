import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/booking/data/datasources/mock_seat_data_source.dart';
import 'package:galaxymob/features/booking/domain/entities/seat.dart';
import 'package:galaxymob/features/booking/domain/repositories/seat_repository.dart';

/// Implementation of SeatRepository
class SeatRepositoryImpl implements SeatRepository {
  final MockSeatDataSource dataSource;

  SeatRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<List<Seat>>>> getSeatLayout({
    required String showtimeId,
    required double basePrice,
  }) async {
    try {
      final seatLayout = dataSource.generateSeatLayout(
        showtimeId: showtimeId,
        basePrice: basePrice,
      );
      return Right(seatLayout);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
