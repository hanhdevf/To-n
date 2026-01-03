import 'package:galaxymob/features/booking/domain/entities/booking.dart';
import 'package:galaxymob/features/booking/domain/entities/seat.dart';

/// Mock booking data source
class MockBookingDataSource {
  final List<Booking> _mockBookings = [];

  /// Get all bookings for a user
  Future<List<Booking>> getUserBookings(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Generate mock bookings if empty
    if (_mockBookings.isEmpty) {
      _mockBookings.addAll(_generateMockBookings(userId));
    }

    return _mockBookings;
  }

  /// Save a new booking
  Future<Booking> saveBooking(Booking booking) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockBookings.add(booking);
    return booking;
  }

  /// Cancel a booking
  Future<bool> cancelBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = _mockBookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _mockBookings[index] = _mockBookings[index].copyWith(
        status: BookingStatus.cancelled,
      );
      return true;
    }
    return false;
  }

  /// Generate some mock bookings
  List<Booking> _generateMockBookings(String userId) {
    final now = DateTime.now();

    return [
      // Active booking 1
      Booking(
        id: 'BOOK-ACT001',
        movieId: '83533',
        movieTitle: 'Avatar: Fire and Ash',
        cinemaId: 'cgv-royal-city',
        cinemaName: 'CGV Royal City',
        showtimeId: 'show-001',
        showtime: now.add(const Duration(days: 2, hours: 3)),
        selectedSeats: [
          Seat(
            id: 'E5',
            row: 'E',
            number: 5,
            type: SeatType.vip,
            status: SeatStatus.booked,
            price: 180000,
          ),
          Seat(
            id: 'E6',
            row: 'E',
            number: 6,
            type: SeatType.vip,
            status: SeatStatus.booked,
            price: 180000,
          ),
        ],
        totalPrice: 360000,
        userName: 'Test User',
        userEmail: 'test@example.com',
        userPhone: '0123456789',
        status: BookingStatus.confirmed,
        paymentMethod: PaymentMethod.momo,
        transactionId: 'TXN-001',
        createdAt: now.subtract(const Duration(days: 1)),
      ),

      // Active booking 2
      Booking(
        id: 'BOOK-ACT002',
        movieId: '558449',
        movieTitle: 'Gladiator II',
        cinemaId: 'lotte-cinema-tay-ho',
        cinemaName: 'Lotte Cinema Tây Hồ',
        showtimeId: 'show-002',
        showtime: now.add(const Duration(days: 5)),
        selectedSeats: [
          Seat(
            id: 'D3',
            row: 'D',
            number: 3,
            type: SeatType.regular,
            status: SeatStatus.booked,
            price: 120000,
          ),
        ],
        totalPrice: 120000,
        userName: 'Test User',
        userEmail: 'test@example.com',
        userPhone: '0123456789',
        status: BookingStatus.confirmed,
        paymentMethod: PaymentMethod.vnPay,
        transactionId: 'TXN-002',
        createdAt: now.subtract(const Duration(hours: 12)),
      ),

      // Past booking
      Booking(
        id: 'BOOK-PAST001',
        movieId: '912649',
        movieTitle: 'Venom: The Last Dance',
        cinemaId: 'galaxy-nguyen-du',
        cinemaName: 'Galaxy Nguyễn Du',
        showtimeId: 'show-003',
        showtime: now.subtract(const Duration(days: 3)),
        selectedSeats: [
          Seat(
            id: 'F7',
            row: 'F',
            number: 7,
            type: SeatType.vip,
            status: SeatStatus.booked,
            price: 180000,
          ),
          Seat(
            id: 'F8',
            row: 'F',
            number: 8,
            type: SeatType.vip,
            status: SeatStatus.booked,
            price: 180000,
          ),
          Seat(
            id: 'F9',
            row: 'F',
            number: 9,
            type: SeatType.vip,
            status: SeatStatus.booked,
            price: 180000,
          ),
        ],
        totalPrice: 540000,
        userName: 'Test User',
        userEmail: 'test@example.com',
        userPhone: '0123456789',
        status: BookingStatus.confirmed,
        paymentMethod: PaymentMethod.creditCard,
        transactionId: 'TXN-003',
        createdAt: now.subtract(const Duration(days: 5)),
      ),
    ];
  }
}
