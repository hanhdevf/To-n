/// Booking business rules and constants
class BookingConstants {
  BookingConstants._();

  /// Maximum number of seats allowed per booking
  static const int maxSeatsPerBooking = 10;

  /// Booking fee rate (5%)
  static const double bookingFeeRate = 0.05;

  /// Seat selection timeout in minutes
  static const int seatSelectionTimeoutMinutes = 15;

  /// Minimum time before showtime to allow booking (minutes)
  static const int minMinutesBeforeShowtime = 30;

  /// Default transaction ID prefix
  static const String transactionIdPrefix = 'TXN-';

  /// Default booking ID prefix
  static const String bookingIdPrefix = 'BOOK-';
}
