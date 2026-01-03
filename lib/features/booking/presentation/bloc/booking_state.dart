import 'package:equatable/equatable.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';

/// Booking States
abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class BookingInitial extends BookingState {
  const BookingInitial();
}

/// Loading bookings
class BookingLoading extends BookingState {
  const BookingLoading();
}

/// Bookings loaded
class BookingsLoaded extends BookingState {
  final List<Booking> bookings;

  const BookingsLoaded(this.bookings);

  @override
  List<Object?> get props => [bookings];

  /// Get active bookings
  List<Booking> get activeBookings => bookings
      .where((b) => b.isUpcoming && b.status == BookingStatus.confirmed)
      .toList();

  /// Get past bookings
  List<Booking> get pastBookings => bookings
      .where((b) => !b.isUpcoming || b.status != BookingStatus.confirmed)
      .toList();
}

/// Booking cancelled
class BookingCancelled extends BookingState {
  final String bookingId;

  const BookingCancelled(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}

/// Error state
class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}
