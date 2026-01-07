import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';
import 'package:galaxymob/features/booking/domain/entities/seat.dart';
import 'package:galaxymob/features/booking/domain/repositories/booking_repository.dart';

/// UseCase for creating a new booking
class CreateBooking implements UseCase<Booking, BookingParams> {
  final BookingRepository repository;

  CreateBooking(this.repository);

  @override
  Future<Either<Failure, Booking>> call(BookingParams params) async {
    // Create booking entity
    final booking = Booking(
      id: params.bookingId,
      movieId: params.movieId,
      movieTitle: params.movieTitle,
      cinemaId: params.cinemaId,
      cinemaName: params.cinemaName,
      showtimeId: params.showtimeId,
      showtime: params.showtime,
      selectedSeats: params.selectedSeats,
      totalPrice: params.totalPrice,
      userName: params.userName,
      userEmail: params.userEmail,
      userPhone: params.userPhone,
      status: BookingStatus.confirmed,
      paymentMethod: params.paymentMethod,
      transactionId: params.transactionId,
      createdAt: DateTime.now(),
    );

    return await repository.createBooking(booking);
  }
}

/// Parameters for creating a booking
class BookingParams extends Equatable {
  final String bookingId;
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
  final PaymentMethod paymentMethod;
  final String transactionId;

  const BookingParams({
    required this.bookingId,
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
    required this.paymentMethod,
    required this.transactionId,
  });

  @override
  List<Object?> get props => [
        bookingId,
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
        paymentMethod,
        transactionId,
      ];
}
