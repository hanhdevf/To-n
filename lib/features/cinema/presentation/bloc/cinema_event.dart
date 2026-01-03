import 'package:equatable/equatable.dart';

/// Cinema Events
abstract class CinemaEvent extends Equatable {
  const CinemaEvent();

  @override
  List<Object?> get props => [];
}

/// Load nearby cinemas
class LoadNearbyCinemasEvent extends CinemaEvent {
  final double? latitude;
  final double? longitude;

  const LoadNearbyCinemasEvent({
    this.latitude,
    this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

/// Load showtimes for a movie
class LoadShowtimesEvent extends CinemaEvent {
  final int movieId;
  final DateTime date;

  const LoadShowtimesEvent({
    required this.movieId,
    required this.date,
  });

  @override
  List<Object?> get props => [movieId, date];
}
