import 'package:equatable/equatable.dart';

/// Showtime entity representing a movie screening
class Showtime extends Equatable {
  final String id;
  final String cinemaId;
  final int movieId;
  final DateTime dateTime;
  final double price;
  final String screenName;
  final int availableSeats;
  final int totalSeats;

  const Showtime({
    required this.id,
    required this.cinemaId,
    required this.movieId,
    required this.dateTime,
    required this.price,
    required this.screenName,
    required this.availableSeats,
    required this.totalSeats,
  });

  @override
  List<Object?> get props => [
        id,
        cinemaId,
        movieId,
        dateTime,
        price,
        screenName,
        availableSeats,
        totalSeats,
      ];

  /// Get formatted time (HH:mm)
  String get formattedTime {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Check if showtime is available
  bool get isAvailable => availableSeats > 0;

  @override
  String toString() =>
      'Showtime(id: $id, time: $formattedTime, available: $availableSeats/$totalSeats)';
}
