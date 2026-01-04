import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/booking/domain/repositories/payment_service.dart';

/// UseCase for verifying a payment
class VerifyPayment implements UseCase<bool, TransactionIdParams> {
  final PaymentService paymentService;

  VerifyPayment(this.paymentService);

  @override
  Future<Either<Failure, bool>> call(TransactionIdParams params) async {
    return await paymentService.verifyPayment(params.transactionId);
  }
}

/// Parameters for transaction ID
class TransactionIdParams extends Equatable {
  final String transactionId;

  const TransactionIdParams({required this.transactionId});

  @override
  List<Object?> get props => [transactionId];
}
