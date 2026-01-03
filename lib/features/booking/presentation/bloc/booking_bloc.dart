import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxymob/features/booking/data/datasources/mock_booking_data_source.dart';
import 'package:galaxymob/features/booking/presentation/bloc/booking_event.dart';
import 'package:galaxymob/features/booking/presentation/bloc/booking_state.dart';

/// BLoC for managing user bookings
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final MockBookingDataSource dataSource;

  BookingBloc({required this.dataSource}) : super(const BookingInitial()) {
    on<LoadBookingsEvent>(_onLoadBookings);
    on<CancelBookingEvent>(_onCancelBooking);
    on<RefreshBookingsEvent>(_onRefreshBookings);
  }

  Future<void> _onLoadBookings(
    LoadBookingsEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingLoading());

    try {
      final bookings = await dataSource.getUserBookings(event.userId);
      emit(BookingsLoaded(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onCancelBooking(
    CancelBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    if (state is! BookingsLoaded) return;

    final currentState = state as BookingsLoaded;

    try {
      final success = await dataSource.cancelBooking(event.bookingId);

      if (success) {
        // Reload bookings
        final bookings = await dataSource.getUserBookings('current-user');
        emit(BookingsLoaded(bookings));
      } else {
        emit(const BookingError('Failed to cancel booking'));
        emit(currentState); // Restore previous state
      }
    } catch (e) {
      emit(BookingError(e.toString()));
      emit(currentState); // Restore previous state
    }
  }

  Future<void> _onRefreshBookings(
    RefreshBookingsEvent event,
    Emitter<BookingState> emit,
  ) async {
    try {
      final bookings = await dataSource.getUserBookings(event.userId);
      emit(BookingsLoaded(bookings));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }
}
