import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:galaxymob/features/booking/domain/constants/booking_constants.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';
import 'package:galaxymob/features/booking/domain/entities/seat.dart';
import 'package:galaxymob/features/booking/domain/usecases/cancel_booking.dart';
import 'package:galaxymob/features/booking/domain/usecases/create_booking.dart';
import 'package:galaxymob/features/booking/domain/usecases/get_user_bookings.dart';
import 'package:galaxymob/features/booking/domain/usecases/update_booking_status.dart';
import 'package:galaxymob/features/booking/presentation/bloc/booking_event.dart';
import 'package:galaxymob/features/booking/presentation/bloc/booking_state.dart';

/// BLoC for managing user bookings
class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final GetUserBookings getUserBookings;
  final CancelBooking cancelBooking;
  final CreateBooking createBooking;
  final UpdateBookingStatus updateBookingStatus;
  final FirebaseAuth auth;

  BookingBloc({
    required this.getUserBookings,
    required this.cancelBooking,
    required this.createBooking,
    required this.updateBookingStatus,
    required this.auth,
  }) : super(const BookingInitial()) {
    on<LoadBookingsEvent>(_onLoadBookings);
    on<CancelBookingEvent>(_onCancelBooking);
    on<RefreshBookingsEvent>(_onRefreshBookings);
    on<CreateBookingEvent>(_onCreateBooking);
    on<UpdateBookingStatusEvent>(_onUpdateBookingStatus);
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
        // Emit cancelled state first
        emit(BookingCancelled(event.bookingId));

        // Then reload bookings after successful cancellation
        final user = auth.currentUser;
        if (user == null) return;

        final bookingsResult = await getUserBookings(
          UserIdParams(userId: user.uid),
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

  Future<void> _onCreateBooking(
    CreateBookingEvent event,
    Emitter<BookingState> emit,
  ) async {
    emit(const BookingCreating());

    try {
      final user = auth.currentUser;
      if (user == null) {
        emit(const BookingError('User not authenticated'));
        return;
      }

      // Generate booking ID
      final bookingId =
          '${BookingConstants.bookingIdPrefix}${const Uuid().v4().substring(0, 8).toUpperCase()}';

      final params = BookingParams(
        bookingId: bookingId,
        movieId: event.movieId,
        movieTitle: event.movieTitle,
        cinemaId: event.cinemaId,
        cinemaName: event.cinemaName,
        showtimeId: event.showtimeId,
        showtime: event.showtime,
        selectedSeats: event.selectedSeats,
        totalPrice: event.totalPrice,
        userName: user.displayName ?? 'User',
        userEmail: user.email ?? '',
        userPhone: user.phoneNumber ?? '',
        paymentMethod: event.paymentMethod,
        transactionId: event.transactionId,
      );

      final result = await createBooking(params);

      result.fold(
        (failure) => emit(BookingError(failure.message)),
        (booking) => emit(BookingCreated(booking)),
      );
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onUpdateBookingStatus(
    UpdateBookingStatusEvent event,
    Emitter<BookingState> emit,
  ) async {
    final result = await updateBookingStatus(
      UpdateBookingStatusParams(
        bookingId: event.bookingId,
        status: event.status,
      ),
    );

    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (_) async {
        // Reload bookings after status update
        final user = auth.currentUser;
        if (user == null) return;

        final bookingsResult = await getUserBookings(
          UserIdParams(userId: user.uid),
        );

        bookingsResult.fold(
          (failure) => emit(BookingError(failure.message)),
          (bookings) => emit(BookingsLoaded(bookings)),
        );
      },
    );
  }

}
