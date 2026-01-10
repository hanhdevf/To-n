import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxymob/features/booking/domain/usecases/initiate_payment.dart';
import 'package:galaxymob/features/booking/domain/usecases/verify_payment.dart';
import 'package:galaxymob/features/booking/presentation/bloc/payment_event.dart';
import 'package:galaxymob/features/booking/presentation/bloc/payment_state.dart';

/// BLoC for handling payment operations
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final InitiatePayment initiatePayment;
  final VerifyPayment verifyPayment;

  PaymentBloc({
    required this.initiatePayment,
    required this.verifyPayment,
  }) : super(const PaymentInitial()) {
    on<InitiatePaymentEvent>(_onInitiatePayment);
    on<VerifyPaymentEvent>(_onVerifyPayment);
    on<ResetPaymentEvent>(_onResetPayment);
  }

  Future<void> _onInitiatePayment(
    InitiatePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentProcessing());

    final result = await initiatePayment(
      PaymentParams(
        booking: event.booking,
        method: event.method,
      ),
    );

    result.fold(
      (failure) => emit(PaymentFailed(failure.message)),
      (transactionId) {
        final resolvedShowtime = _resolveShowtime(
          event.showtimeDateTime,
          event.showtimeText,
        );
        emit(PaymentSuccess(transactionId, resolvedShowtime));
      },
    );
  }

  Future<void> _onVerifyPayment(
    VerifyPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentProcessing());

    final result = await verifyPayment(
      TransactionIdParams(transactionId: event.transactionId),
    );

    result.fold(
      (failure) => emit(PaymentFailed(failure.message)),
      (isVerified) {
        if (isVerified) {
          // In verify flow we don't have showtime context, pass current time
          emit(PaymentSuccess(event.transactionId, DateTime.now()));
        } else {
          emit(const PaymentFailed('Payment verification failed'));
        }
      },
    );
  }

  void _onResetPayment(
    ResetPaymentEvent event,
    Emitter<PaymentState> emit,
  ) {
    emit(const PaymentInitial());
  }

  DateTime _resolveShowtime(DateTime? provided, String fallbackText) {
    if (provided != null) return provided;
    try {
      final now = DateTime.now();
      final parts = fallbackText.split(':');
      if (parts.length == 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null && minute != null) {
          return DateTime(now.year, now.month, now.day, hour, minute);
        }
      }
    } catch (_) {}
    return DateTime.now();
  }
}
