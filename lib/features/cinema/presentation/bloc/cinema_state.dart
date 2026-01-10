import 'package:equatable/equatable.dart';
import 'package:galaxymob/features/cinema/domain/entities/cinema.dart';
import 'package:galaxymob/features/cinema/domain/entities/showtime.dart';

/// Cinema States
abstract class CinemaState extends Equatable {
  const CinemaState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class CinemaInitial extends CinemaState {
  const CinemaInitial();
}

/// Loading state
class CinemaLoading extends CinemaState {
  const CinemaLoading();
}

/// Cinemas loaded
class CinemasLoaded extends CinemaState {
  final List<Cinema> cinemas;

  const CinemasLoaded(this.cinemas);

  @override
  List<Object?> get props => [cinemas];
}

/// Showtimes loaded (grouped by cinema)
class ShowtimesLoaded extends CinemaState {
  final Map<String, List<Showtime>> showtimesByCinema;
  final List<Cinema> cinemas;
  final DateTime selectedDate;
  final List<DateTime> availableDates;

  const ShowtimesLoaded({
    required this.showtimesByCinema,
    required this.cinemas,
    required this.selectedDate,
    required this.availableDates,
  });

  @override
  List<Object?> get props =>
      [showtimesByCinema, cinemas, selectedDate, availableDates];
}

/// Error state
class CinemaError extends CinemaState {
  final String message;

  const CinemaError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Schedule loaded (movies with their showtimes)
class ScheduleLoaded extends CinemaState {
  final Map<int, List<Showtime>> showtimesByMovie;
  final DateTime date;

  const ScheduleLoaded({
    required this.showtimesByMovie,
    required this.date,
  });

  @override
  List<Object?> get props => [showtimesByMovie, date];
}
