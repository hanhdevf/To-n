import 'package:galaxymob/features/booking/domain/entities/seat.dart';
import 'package:galaxymob/features/movies/domain/entities/review.dart';

class SeatSelectionArgs {
  final String showtimeId;
  final String movieTitle;
  final String cinemaName;
  final String showtime;
  final DateTime? showtimeDateTime;
  final double basePrice;

  const SeatSelectionArgs({
    required this.showtimeId,
    required this.movieTitle,
    required this.cinemaName,
    required this.showtime,
    required this.basePrice,
    this.showtimeDateTime,
  });
}

class BookingSummaryArgs {
  final String movieTitle;
  final String cinemaName;
  final String showtime;
  final DateTime? showtimeDateTime;
  final List<Seat> selectedSeats;
  final double totalPrice;
  final String? movieId;
  final String? cinemaId;
  final String? showtimeId;

  const BookingSummaryArgs({
    required this.movieTitle,
    required this.cinemaName,
    required this.showtime,
    required this.selectedSeats,
    required this.totalPrice,
    this.showtimeDateTime,
    this.movieId,
    this.cinemaId,
    this.showtimeId,
  });
}

class AllReviewsArgs {
  final List<Review> reviews;
  final String movieTitle;

  const AllReviewsArgs({required this.reviews, required this.movieTitle});
}

class MovieShowtimeArgs {
  final int movieId;
  final String movieTitle;

  const MovieShowtimeArgs({
    required this.movieId,
    required this.movieTitle,
  });
}
