import 'package:equatable/equatable.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';

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

/// Create a new booking
class CreateBookingEvent extends BookingEvent {
  final String movieId;
  final String movieTitle;
  final String cinemaId;
  final String cinemaName;
  final String showtimeId;
  final DateTime showtime;
  final List<dynamic> selectedSeats; // Will be List<Seat> or List<String>
  final double totalPrice;
  final String paymentMethod;
  final String transactionId;

  const CreateBookingEvent({
    required this.movieId,
    required this.movieTitle,
    required this.cinemaId,
    required this.cinemaName,
    required this.showtimeId,
    required this.showtime,
    required this.selectedSeats,
    required this.totalPrice,
    required this.paymentMethod,
    required this.transactionId,
  });

  @override
  List<Object?> get props => [
        movieId,
        movieTitle,
        cinemaId,
        cinemaName,
        showtimeId,
        showtime,
        selectedSeats,
        totalPrice,
        paymentMethod,
        transactionId,
      ];
}

/// Update booking status
class UpdateBookingStatusEvent extends BookingEvent {
  final String bookingId;
  final BookingStatus status;

  const UpdateBookingStatusEvent(this.bookingId, this.status);

  @override
  List<Object?> get props => [bookingId, status];
}
