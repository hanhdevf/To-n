import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';

/// Payment service interface for handling payment operations
abstract class PaymentService {
  /// Initiate a payment for a booking
  /// Returns transaction ID on success
  /// Booking is nullable for mock payment implementations
  Future<Either<Failure, String>> initiatePayment({
    Booking? booking,
    required PaymentMethod method,
  });

  /// Verify payment status
  Future<Either<Failure, bool>> verifyPayment(String transactionId);

  /// Get payment status
  Future<Either<Failure, PaymentStatus>> getPaymentStatus(String transactionId);
}

/// Payment status enum
enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
}
