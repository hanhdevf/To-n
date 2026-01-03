import 'package:equatable/equatable.dart';
import 'package:galaxymob/features/booking/domain/entities/seat.dart';

/// Booking entity representing a complete cinema booking
class Booking extends Equatable {
  final String id;
  final String movieId;
  final String movieTitle;
  final String cinemaId;
  final String cinemaName;
  final String showtimeId;
  final DateTime showtime;
  final List<Seat> selectedSeats;
  final double totalPrice;
  final String userName;
  final String userEmail;
  final String userPhone;
  final BookingStatus status;
  final PaymentMethod paymentMethod;
  final String? transactionId;
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    required this.cinemaId,
    required this.cinemaName,
    required this.showtimeId,
    required this.showtime,
    required this.selectedSeats,
    required this.totalPrice,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.status,
    required this.paymentMethod,
    this.transactionId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        movieId,
        movieTitle,
        cinemaId,
        cinemaName,
        showtimeId,
        showtime,
        selectedSeats,
        totalPrice,
        userName,
        userEmail,
        userPhone,
        status,
        paymentMethod,
        transactionId,
        createdAt,
      ];

  /// Get formatted seat numbers (e.g., "A1, A2, B3")
  String get formattedSeats =>
      selectedSeats.map((s) => s.displayName).join(', ');

  /// Get total number of tickets
  int get ticketCount => selectedSeats.length;

  /// Check if booking is upcoming
  bool get isUpcoming => showtime.isAfter(DateTime.now());

  /// Copy with method for creating modified copies
  Booking copyWith({
    String? id,
    String? movieId,
    String? movieTitle,
    String? cinemaId,
    String? cinemaName,
    String? showtimeId,
    DateTime? showtime,
    List<Seat>? selectedSeats,
    double? totalPrice,
    String? userName,
    String? userEmail,
    String? userPhone,
    BookingStatus? status,
    PaymentMethod? paymentMethod,
    String? transactionId,
    DateTime? createdAt,
  }) {
    return Booking(
      id: id ?? this.id,
      movieId: movieId ?? this.movieId,
      movieTitle: movieTitle ?? this.movieTitle,
      cinemaId: cinemaId ?? this.cinemaId,
      cinemaName: cinemaName ?? this.cinemaName,
      showtimeId: showtimeId ?? this.showtimeId,
      showtime: showtime ?? this.showtime,
      selectedSeats: selectedSeats ?? this.selectedSeats,
      totalPrice: totalPrice ?? this.totalPrice,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPhone: userPhone ?? this.userPhone,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Booking status enum
enum BookingStatus {
  pending,
  confirmed,
  cancelled,
  expired,
}

/// Payment method enum
enum PaymentMethod {
  creditCard,
  momo,
  zaloPay,
  vnPay,
}

extension PaymentMethodExtension on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.momo:
        return 'MoMo E-Wallet';
      case PaymentMethod.zaloPay:
        return 'ZaloPay';
      case PaymentMethod.vnPay:
        return 'VNPay';
    }
  }
}
