import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:galaxymob/features/cinema/domain/entities/showtime.dart';
import 'package:json_annotation/json_annotation.dart';

part 'showtime_model.g.dart';

/// Firestore data model for Showtime
@JsonSerializable()
class ShowtimeModel {
  final String id;
  @JsonKey(name: 'cinema_id')
  final String cinemaId;
  @JsonKey(name: 'movie_id')
  final int movieId;
  @JsonKey(
      name: 'start_time',
      fromJson: _timestampFromJson,
      toJson: _timestampToJson)
  final DateTime startTime;
  final double price;
  @JsonKey(name: 'screen_name')
  final String screenName;
  @JsonKey(name: 'booked_seats')
  final List<String> bookedSeats;
  @JsonKey(name: 'total_seats')
  final int totalSeats;
  @JsonKey(name: 'layout_type')
  final String? layoutType;

  const ShowtimeModel({
    required this.id,
    required this.cinemaId,
    required this.movieId,
    required this.startTime,
    required this.price,
    required this.screenName,
    required this.bookedSeats,
    required this.totalSeats,
    this.layoutType,
  });

  /// Convert from Firestore document
  factory ShowtimeModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('Showtime document is null');
    }

    return ShowtimeModel(
      id: snapshot.id,
      cinemaId: data['cinema_id'] as String,
      movieId: data['movie_id'] as int,
      startTime: (data['start_time'] as Timestamp).toDate(),
      price: (data['price'] as num).toDouble(),
      screenName: data['screen_name'] as String,
      bookedSeats: (data['booked_seats'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      totalSeats: data['total_seats'] as int,
      layoutType: data['layout_type'] as String?,
    );
  }

  /// Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'cinema_id': cinemaId,
      'movie_id': movieId,
      'start_time': Timestamp.fromDate(startTime),
      'price': price,
      'screen_name': screenName,
      'booked_seats': bookedSeats,
      'total_seats': totalSeats,
      if (layoutType != null) 'layout_type': layoutType,
    };
  }

  /// Convert from JSON
  factory ShowtimeModel.fromJson(Map<String, dynamic> json) =>
      _$ShowtimeModelFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$ShowtimeModelToJson(this);

  /// Convert to domain entity
  Showtime toEntity() {
    return Showtime(
      id: id,
      cinemaId: cinemaId,
      movieId: movieId,
      dateTime: startTime,
      price: price,
      screenName: screenName,
      availableSeats: totalSeats - bookedSeats.length,
      totalSeats: totalSeats,
    );
  }

  /// Create from domain entity
  factory ShowtimeModel.fromEntity(Showtime showtime) {
    return ShowtimeModel(
      id: showtime.id,
      cinemaId: showtime.cinemaId,
      movieId: showtime.movieId,
      startTime: showtime.dateTime,
      price: showtime.price,
      screenName: showtime.screenName,
      bookedSeats: [], // Will be populated separately
      totalSeats: showtime.totalSeats,
    );
  }

  /// Helper method to convert Timestamp to DateTime for JSON serialization
  static DateTime _timestampFromJson(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is String) {
      return DateTime.parse(timestamp);
    }
    throw ArgumentError('Invalid timestamp format');
  }

  /// Helper method to convert DateTime to Timestamp for JSON serialization
  static dynamic _timestampToJson(DateTime dateTime) {
    return dateTime.toIso8601String();
  }
}
