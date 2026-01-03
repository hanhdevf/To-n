import 'package:equatable/equatable.dart';

/// Booking Events
abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

/// Load user bookings
class LoadBookingsEvent extends BookingEvent {
  final String userId;

  const LoadBookingsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// Cancel a booking
class CancelBookingEvent extends BookingEvent {
  final String bookingId;

  const CancelBookingEvent(this.bookingId);

  @override
  List<Object?> get props => [bookingId];
}

/// Refresh bookings
class RefreshBookingsEvent extends BookingEvent {
  final String userId;

  const RefreshBookingsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}
