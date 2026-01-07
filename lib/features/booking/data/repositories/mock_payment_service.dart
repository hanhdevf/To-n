import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';
import 'package:galaxymob/features/booking/domain/repositories/payment_service.dart';

/// Mock payment service implementation for MVP
/// Simulates payment flow with delays
class MockPaymentService implements PaymentService {
  final _uuid = const Uuid();

  @override
  Future<Either<Failure, String>> initiatePayment({
    Booking? booking,
    required PaymentMethod method,
  }) async {
    try {
      // Simulate payment processing delay
      await Future.delayed(const Duration(seconds: 2));

      // For mock, always succeed and generate transaction ID
      final transactionId = 'TXN-${_uuid.v4().substring(0, 8).toUpperCase()}';

      return Right(transactionId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyPayment(String transactionId) async {
    try {
      // Simulate verification delay
      await Future.delayed(const Duration(milliseconds: 500));

      // For mock, always return true
      return const Right(true);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PaymentStatus>> getPaymentStatus(
      String transactionId) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 300));

      // For mock, always return completed
      return const Right(PaymentStatus.completed);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
