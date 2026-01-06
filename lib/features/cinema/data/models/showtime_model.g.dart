// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'showtime_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowtimeModel _$ShowtimeModelFromJson(Map<String, dynamic> json) =>
    ShowtimeModel(
      id: json['id'] as String,
      cinemaId: json['cinema_id'] as String,
      movieId: (json['movie_id'] as num).toInt(),
      startTime: ShowtimeModel._timestampFromJson(json['start_time']),
      price: (json['price'] as num).toDouble(),
      screenName: json['screen_name'] as String,
      bookedSeats: (json['booked_seats'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      totalSeats: (json['total_seats'] as num).toInt(),
      layoutType: json['layout_type'] as String?,
    );

Map<String, dynamic> _$ShowtimeModelToJson(ShowtimeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cinema_id': instance.cinemaId,
      'movie_id': instance.movieId,
      'start_time': ShowtimeModel._timestampToJson(instance.startTime),
      'price': instance.price,
      'screen_name': instance.screenName,
      'booked_seats': instance.bookedSeats,
      'total_seats': instance.totalSeats,
      'layout_type': instance.layoutType,
    };
