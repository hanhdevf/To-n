import 'package:equatable/equatable.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';

/// Ticket entity representing a generated cinema ticket with QR code
class Ticket extends Equatable {
  final String id;
  final Booking booking;
  final String qrData;
  final DateTime generatedAt;
  final DateTime expiresAt;
  final bool isUsed;
  final DateTime? usedAt;

  const Ticket({
    required this.id,
    required this.booking,
    required this.qrData,
    required this.generatedAt,
    required this.expiresAt,
    this.isUsed = false,
    this.usedAt,
  });

  @override
  List<Object?> get props => [
        id,
        booking,
        qrData,
        generatedAt,
        expiresAt,
        isUsed,
        usedAt,
      ];

  /// Check if ticket is still valid
  bool get isValid =>
      !isUsed &&
      DateTime.now().isBefore(expiresAt) &&
      booking.status == BookingStatus.confirmed;

  /// Check if ticket is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Generate QR data string from booking info
  static String generateQRData(Booking booking) {
    // Format: BOOKING_ID|MOVIE_ID|SHOWTIME|SEATS|USER_EMAIL
    return '${booking.id}|${booking.movieId}|${booking.showtimeId}|${booking.formattedSeats}|${booking.userEmail}';
  }

  /// Copy with method
  Ticket copyWith({
    String? id,
    Booking? booking,
    String? qrData,
    DateTime? generatedAt,
    DateTime? expiresAt,
    bool? isUsed,
    DateTime? usedAt,
  }) {
    return Ticket(
      id: id ?? this.id,
      booking: booking ?? this.booking,
      qrData: qrData ?? this.qrData,
      generatedAt: generatedAt ?? this.generatedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isUsed: isUsed ?? this.isUsed,
      usedAt: usedAt ?? this.usedAt,
    );
  }

  /// Mark ticket as used
  Ticket markAsUsed() {
    return copyWith(
      isUsed: true,
      usedAt: DateTime.now(),
    );
  }
}
