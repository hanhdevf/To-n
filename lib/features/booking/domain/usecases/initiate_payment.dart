import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';
import 'package:galaxymob/features/booking/domain/repositories/payment_service.dart';

/// UseCase for initiating a payment
class InitiatePayment implements UseCase<String, PaymentParams> {
  final PaymentService paymentService;

  InitiatePayment(this.paymentService);

  @override
  Future<Either<Failure, String>> call(PaymentParams params) async {
    return await paymentService.initiatePayment(
      booking: params.booking,
      method: params.method,
    );
  }
}

/// Parameters for payment
class PaymentParams extends Equatable {
  final Booking? booking;
  final PaymentMethod method;

  const PaymentParams({
    this.booking,
    required this.method,
  });

  @override
  List<Object?> get props => [booking, method];
}
