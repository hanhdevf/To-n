// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeatData _$SeatDataFromJson(Map<String, dynamic> json) => SeatData(
      id: json['id'] as String,
      row: json['row'] as String,
      number: (json['number'] as num).toInt(),
      type: json['type'] as String,
      price: (json['price'] as num).toDouble(),
    );

Map<String, dynamic> _$SeatDataToJson(SeatData instance) => <String, dynamic>{
      'id': instance.id,
      'row': instance.row,
      'number': instance.number,
      'type': instance.type,
      'price': instance.price,
    };

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      showtimeId: json['showtime_id'] as String,
      movieId: json['movie_id'] as String,
      movieTitle: json['movie_title'] as String,
      cinemaId: json['cinema_id'] as String,
      cinemaName: json['cinema_name'] as String,
      showtime: BookingModel._timestampFromJson(json['showtime']),
      seats: (json['seats'] as List<dynamic>)
          .map((e) => SeatData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPrice: (json['total_price'] as num).toDouble(),
      userName: json['user_name'] as String,
      userEmail: json['user_email'] as String,
      userPhone: json['user_phone'] as String,
      status: json['status'] as String,
      paymentMethod: json['payment_method'] as String,
      transactionId: json['transaction_id'] as String?,
      createdAt: BookingModel._timestampFromJson(json['created_at']),
    );

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'showtime_id': instance.showtimeId,
      'movie_id': instance.movieId,
      'movie_title': instance.movieTitle,
      'cinema_id': instance.cinemaId,
      'cinema_name': instance.cinemaName,
      'showtime': BookingModel._timestampToJson(instance.showtime),
      'seats': instance.seats.map((e) => e.toJson()).toList(),
      'total_price': instance.totalPrice,
      'user_name': instance.userName,
      'user_email': instance.userEmail,
      'user_phone': instance.userPhone,
      'status': instance.status,
      'payment_method': instance.paymentMethod,
      'transaction_id': instance.transactionId,
      'created_at': BookingModel._timestampToJson(instance.createdAt),
    };
