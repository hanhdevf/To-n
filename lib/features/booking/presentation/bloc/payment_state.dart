import 'package:equatable/equatable.dart';

/// Payment States
abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

/// Payment processing
class PaymentProcessing extends PaymentState {
  const PaymentProcessing();
}

/// Payment successful
class PaymentSuccess extends PaymentState {
  final String transactionId;

  const PaymentSuccess(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}

/// Payment failed
class PaymentFailed extends PaymentState {
  final String message;

  const PaymentFailed(this.message);

  @override
  List<Object?> get props => [message];
}
