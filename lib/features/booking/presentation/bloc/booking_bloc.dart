import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxymob/features/booking/domain/usecases/cancel_booking.dart';
import 'package:galaxymob/features/booking/domain/usecases/get_user_bookings.dart';
import 'package:galaxymob/features/booking/presentation/bloc/booking_event.dart';
import 'package:galaxymob/features/booking/presentation/bloc/booking_state.dart';

/// BLoC for managing user bookings
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetUserBookings getUserBookings;
  final CancelBooking cancelBooking;

  BookingBloc({
    required this.getUserBookings,
    required this.cancelBooking,
  }) : super(const BookingInitial()) {
    on<LoadBookingsEvent>(_onLoadBookings);
    on<CancelBookingEvent>(_onCancelBooking);
    on<RefreshBookingsEvent>(_onRefreshBookings);
  }

  Future<void> _onLoadBookings(
    LoadBookingsEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());

    final result = await getUserBookings(UserIdParams(userId: event.userId));

    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (bookings) => emit(BookingsLoaded(bookings)),
    );
  }

  Future<void> _onCancelBooking(
    CancelBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    if (state is! BookingsLoaded) return;

    final currentState = state as BookingsLoaded;

    final result = await cancelBooking(
      BookingIdParams(bookingId: event.bookingId),
    );

    await result.fold(
      (failure) async {
        emit(BookingError(failure.message));
        emit(currentState); // Restore previous state
      },
      (_) async {
        // Reload bookings after successful cancellation
        final bookingsResult = await getUserBookings(
          const UserIdParams(userId: 'current-user'),
        );

        bookingsResult.fold(
          (failure) => emit(BookingError(failure.message)),
          (bookings) => emit(BookingsLoaded(bookings)),
        );
      },
    );
  }

  Future<void> _onRefreshBookings(
    RefreshBookingsEvent event,
    Emitter<BookingState> emit,
  ) async {
    final result = await getUserBookings(UserIdParams(userId: event.userId));

    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (bookings) => emit(BookingsLoaded(bookings)),
    );
  }
}
