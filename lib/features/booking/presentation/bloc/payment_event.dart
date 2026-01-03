import 'package:equatable/equatable.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';

/// Payment Events
abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

/// Initiate payment for a booking
class InitiatePaymentEvent extends PaymentEvent {
  final Booking booking;
  final PaymentMethod method;

  const InitiatePaymentEvent({
    required this.booking,
    required this.method,
  });

  @override
  List<Object?> get props => [booking, method];
}

/// Verify a payment transaction
class VerifyPaymentEvent extends PaymentEvent {
  final String transactionId;

  const VerifyPaymentEvent(this.transactionId);

  @override
  List<Object?> get props => [transactionId];
}

/// Reset payment state
class ResetPaymentEvent extends PaymentEvent {
  const ResetPaymentEvent();
}
