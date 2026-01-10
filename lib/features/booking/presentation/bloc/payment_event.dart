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
  final Booking? booking; // Made nullable since mock payment doesn't need it
  final PaymentMethod method;
  final String showtimeText;
  final DateTime? showtimeDateTime;

  const InitiatePaymentEvent({
    this.booking,
    required this.method,
    required this.showtimeText,
    this.showtimeDateTime,
  });

  @override
  List<Object?> get props => [booking, method, showtimeText, showtimeDateTime];
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
