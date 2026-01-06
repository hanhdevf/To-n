import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';
import 'package:galaxymob/features/booking/domain/entities/seat.dart';
import 'package:json_annotation/json_annotation.dart';

part 'booking_model.g.dart';

/// Simplified seat data for Firestore storage
@JsonSerializable()
class SeatData {
  final String id;
  final String row;
  final int number;
  final String type;
  final double price;

  const SeatData({
    required this.id,
    required this.row,
    required this.number,
    required this.type,
    required this.price,
  });

  factory SeatData.fromJson(Map<String, dynamic> json) =>
      _$SeatDataFromJson(json);

  Map<String, dynamic> toJson() => _$SeatDataToJson(this);

  /// Convert to Seat entity
  Seat toEntity() {
    return Seat(
      id: id,
      row: row,
      number: number,
      type: _stringToSeatType(type),
      status: SeatStatus.booked, // Booked seats in booking history
      price: price,
    );
  }

  /// Create from Seat entity
  factory SeatData.fromEntity(Seat seat) {
    return SeatData(
      id: seat.id,
      row: seat.row,
      number: seat.number,
      type: _seatTypeToString(seat.type),
      price: seat.price,
    );
  }

  static SeatType _stringToSeatType(String type) {
    switch (type) {
      case 'regular':
        return SeatType.regular;
      case 'vip':
        return SeatType.vip;
      case 'couple':
        return SeatType.couple;
      default:
        return SeatType.regular;
    }
  }

  static String _seatTypeToString(SeatType type) {
    switch (type) {
      case SeatType.regular:
        return 'regular';
      case SeatType.vip:
        return 'vip';
      case SeatType.couple:
        return 'couple';
    }
  }
}

/// Firestore data model for Booking
@JsonSerializable(explicitToJson: true)
class BookingModel {
  final String id;
  @JsonKey(name: 'user_id')
  final String userId;
  @JsonKey(name: 'showtime_id')
  final String showtimeId;
  @JsonKey(name: 'movie_id')
  final String movieId;
  @JsonKey(name: 'movie_title')
  final String movieTitle;
  @JsonKey(name: 'cinema_id')
  final String cinemaId;
  @JsonKey(name: 'cinema_name')
  final String cinemaName;
  @JsonKey(
      name: 'showtime', fromJson: _timestampFromJson, toJson: _timestampToJson)
  final DateTime showtime;
  final List<SeatData> seats;
  @JsonKey(name: 'total_price')
  final double totalPrice;
  @JsonKey(name: 'user_name')
  final String userName;
  @JsonKey(name: 'user_email')
  final String userEmail;
  @JsonKey(name: 'user_phone')
  final String userPhone;
  final String status;
  @JsonKey(name: 'payment_method')
  final String paymentMethod;
  @JsonKey(name: 'transaction_id')
  final String? transactionId;
  @JsonKey(
      name: 'created_at',
      fromJson: _timestampFromJson,
      toJson: _timestampToJson)
  final DateTime createdAt;

  const BookingModel({
    required this.id,
    required this.userId,
    required this.showtimeId,
    required this.movieId,
    required this.movieTitle,
    required this.cinemaId,
    required this.cinemaName,
    required this.showtime,
    required this.seats,
    required this.totalPrice,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    required this.status,
    required this.paymentMethod,
    this.transactionId,
    required this.createdAt,
  });

  /// Convert from Firestore document
  factory BookingModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('Booking document is null');
    }

    return BookingModel(
      id: snapshot.id,
      userId: data['user_id'] as String,
      showtimeId: data['showtime_id'] as String,
      movieId: data['movie_id'] as String,
      movieTitle: data['movie_title'] as String,
      cinemaId: data['cinema_id'] as String,
      cinemaName: data['cinema_name'] as String,
      showtime: (data['showtime'] as Timestamp).toDate(),
      seats: (data['seats'] as List<dynamic>)
          .map((e) => SeatData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPrice: (data['total_price'] as num).toDouble(),
      userName: data['user_name'] as String,
      userEmail: data['user_email'] as String,
      userPhone: data['user_phone'] as String,
      status: data['status'] as String,
      paymentMethod: data['payment_method'] as String,
      transactionId: data['transaction_id'] as String?,
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userId,
      'showtime_id': showtimeId,
      'movie_id': movieId,
      'movie_title': movieTitle,
      'cinema_id': cinemaId,
      'cinema_name': cinemaName,
      'showtime': Timestamp.fromDate(showtime),
      'seats': seats.map((s) => s.toJson()).toList(),
      'total_price': totalPrice,
      'user_name': userName,
      'user_email': userEmail,
      'user_phone': userPhone,
      'status': status,
      'payment_method': paymentMethod,
      if (transactionId != null) 'transaction_id': transactionId,
      'created_at': Timestamp.fromDate(createdAt),
    };
  }

  /// Convert from JSON
  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$BookingModelToJson(this);

  /// Convert to domain entity
  Booking toEntity() {
    return Booking(
      id: id,
      movieId: movieId,
      movieTitle: movieTitle,
      cinemaId: cinemaId,
      cinemaName: cinemaName,
      showtimeId: showtimeId,
      showtime: showtime,
      selectedSeats: seats.map((s) => s.toEntity()).toList(),
      totalPrice: totalPrice,
      userName: userName,
      userEmail: userEmail,
      userPhone: userPhone,
      status: _stringToBookingStatus(status),
      paymentMethod: _stringToPaymentMethod(paymentMethod),
      transactionId: transactionId,
      createdAt: createdAt,
    );
  }

  /// Create from domain entity
  factory BookingModel.fromEntity(Booking booking, String userId) {
    return BookingModel(
      id: booking.id,
      userId: userId,
      showtimeId: booking.showtimeId,
      movieId: booking.movieId,
      movieTitle: booking.movieTitle,
      cinemaId: booking.cinemaId,
      cinemaName: booking.cinemaName,
      showtime: booking.showtime,
      seats: booking.selectedSeats.map((s) => SeatData.fromEntity(s)).toList(),
      totalPrice: booking.totalPrice,
      userName: booking.userName,
      userEmail: booking.userEmail,
      userPhone: booking.userPhone,
      status: _bookingStatusToString(booking.status),
      paymentMethod: _paymentMethodToString(booking.paymentMethod),
      transactionId: booking.transactionId,
      createdAt: booking.createdAt,
    );
  }

  /// Helper methods for enum conversions
  static BookingStatus _stringToBookingStatus(String status) {
    switch (status) {
      case 'pending':
        return BookingStatus.pending;
      case 'confirmed':
        return BookingStatus.confirmed;
      case 'cancelled':
        return BookingStatus.cancelled;
      case 'expired':
        return BookingStatus.expired;
      default:
        return BookingStatus.pending;
    }
  }

  static String _bookingStatusToString(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'pending';
      case BookingStatus.confirmed:
        return 'confirmed';
      case BookingStatus.cancelled:
        return 'cancelled';
      case BookingStatus.expired:
        return 'expired';
    }
  }

  static PaymentMethod _stringToPaymentMethod(String method) {
    switch (method) {
      case 'credit_card':
        return PaymentMethod.creditCard;
      case 'momo':
        return PaymentMethod.momo;
      case 'zalo_pay':
        return PaymentMethod.zaloPay;
      case 'vn_pay':
        return PaymentMethod.vnPay;
      default:
        return PaymentMethod.momo;
    }
  }

  static String _paymentMethodToString(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.creditCard:
        return 'credit_card';
      case PaymentMethod.momo:
        return 'momo';
      case PaymentMethod.zaloPay:
        return 'zalo_pay';
      case PaymentMethod.vnPay:
        return 'vn_pay';
    }
  }

  static DateTime _timestampFromJson(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is String) {
      return DateTime.parse(timestamp);
    }
    throw ArgumentError('Invalid timestamp format');
  }

  static dynamic _timestampToJson(DateTime dateTime) {
    return dateTime.toIso8601String();
  }
}
