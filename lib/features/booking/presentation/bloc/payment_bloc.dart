import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxymob/features/booking/domain/repositories/payment_service.dart';
import 'package:galaxymob/features/booking/presentation/bloc/payment_event.dart';
import 'package:galaxymob/features/booking/presentation/bloc/payment_state.dart';

/// BLoC for handling payment operations
class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentService paymentService;

  PaymentBloc({required this.paymentService}) : super(const PaymentInitial()) {
    on<InitiatePaymentEvent>(_onInitiatePayment);
    on<VerifyPaymentEvent>(_onVerifyPayment);
    on<ResetPaymentEvent>(_onResetPayment);
  }

  Future<void> _onInitiatePayment(
    InitiatePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentProcessing());

    final result = await paymentService.initiatePayment(
      booking: event.booking,
      method: event.method,
    );

    result.fold(
      (failure) => emit(PaymentFailed(failure.message)),
      (transactionId) => emit(PaymentSuccess(transactionId)),
    );
  }

  Future<void> _onVerifyPayment(
    VerifyPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentProcessing());

    final result = await paymentService.verifyPayment(event.transactionId);

    result.fold(
      (failure) => emit(PaymentFailed(failure.message)),
      (isVerified) {
        if (isVerified) {
          emit(PaymentSuccess(event.transactionId));
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
}
