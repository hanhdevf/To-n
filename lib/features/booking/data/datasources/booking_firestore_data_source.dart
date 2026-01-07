import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:galaxymob/features/booking/data/models/booking_model.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';
import 'package:galaxymob/features/cinema/data/models/showtime_model.dart';

/// Firestore data source for booking operations
class BookingFirestoreDataSource {
  final FirebaseFirestore _firestore;

  BookingFirestoreDataSource(this._firestore);

  /// Get user bookings
  Future<List<BookingModel>> getUserBookings(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('bookings')
          .where('user_id', isEqualTo: userId)
          .orderBy('created_at', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => BookingModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch bookings: $e');
    }
  }

  /// Create booking with transaction (prevents double-booking)
  /// Returns the booking ID if successful, throws exception if seats already booked
  Future<String> createBooking({
    required BookingModel booking,
    required List<String> seatIds,
  }) async {
    try {
      final bookingId = await _firestore.runTransaction<String>(
        (transaction) async {
          // 1. Read showtime document
          final showtimeRef =
              _firestore.collection('showtimes').doc(booking.showtimeId);
          final showtimeDoc = await transaction.get(showtimeRef);

          if (!showtimeDoc.exists) {
            throw Exception('Showtime not found');
          }

          final showtime = ShowtimeModel.fromFirestore(showtimeDoc);

          // 2. Check if any requested seats are already booked
          final alreadyBooked =
              seatIds.any((seat) => showtime.bookedSeats.contains(seat));

          if (alreadyBooked) {
            throw Exception('One or more seats are already booked');
          }

          // 3. Update showtime with new booked seats
          final updatedBookedSeats = [
            ...showtime.bookedSeats,
            ...seatIds,
          ];

          transaction.update(showtimeRef, {
            'booked_seats': updatedBookedSeats,
          });

          // 4. Create booking document
          final bookingRef = _firestore.collection('bookings').doc();
          transaction.set(bookingRef, booking.toFirestore());

          return bookingRef.id;
        },
        timeout: const Duration(seconds: 10),
      );

      return bookingId;
    } on FirebaseException catch (e) {
      if (e.code == 'aborted') {
        throw Exception('Booking conflict: Seats may have been taken');
      }
      throw Exception('Failed to create booking: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }

  /// Cancel booking and release seats
  Future<void> cancelBooking(String bookingId) async {
    try {
      // First, get the booking to know which seats to release
      final bookingDoc =
          await _firestore.collection('bookings').doc(bookingId).get();
      if (!bookingDoc.exists) {
        throw Exception('Booking not found');
      }

      final bookingData = bookingDoc.data()!;
      final showtimeId = bookingData['showtime_id'] as String;

      // Safely get seat IDs, handle null case
      final seatsData = bookingData['selected_seats'];
      final List<String> seats = [];

      if (seatsData != null && seatsData is List) {
        for (var seatData in seatsData) {
          if (seatData is Map && seatData['id'] != null) {
            seats.add(seatData['id'] as String);
          }
        }
      }

      // Update booking status and release seats in showtime atomically
      final batch = _firestore.batch();

      // Update booking status
      batch.update(
        _firestore.collection('bookings').doc(bookingId),
        {'status': 'cancelled'},
      );

      // Remove seats from showtime's bookedSeats
      batch.update(
        _firestore.collection('showtimes').doc(showtimeId),
        {'booked_seats': FieldValue.arrayRemove(seats)},
      );

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  /// Update booking status (e.g., to 'completed' when ticket is generated)
  Future<void> updateBookingStatus(
    String bookingId,
    BookingStatus status,
  ) async {
    try {
      await _firestore.collection('bookings').doc(bookingId).update({
        'status': _bookingStatusToString(status),
      });
    } catch (e) {
      throw Exception('Failed to update booking status: $e');
    }
  }

  /// Helper to convert BookingStatus enum to string
  String _bookingStatusToString(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'pending';
      case BookingStatus.confirmed:
        return 'confirmed';
      case BookingStatus.completed:
        return 'completed';
      case BookingStatus.cancelled:
        return 'cancelled';
      case BookingStatus.expired:
        return 'expired';
    }
  }

  /// Get booking by ID
  Future<BookingModel> getBooking(String bookingId) async {
    try {
      final doc = await _firestore.collection('bookings').doc(bookingId).get();
      if (!doc.exists) {
        throw Exception('Booking not found');
      }
      return BookingModel.fromFirestore(doc);
    } catch (e) {
      throw Exception('Failed to fetch booking: $e');
    }
  }

  /// Stream user bookings for real-time updates
  Stream<List<BookingModel>> watchUserBookings(String userId) {
    return _firestore
        .collection('bookings')
        .where('user_id', isEqualTo: userId)
        .orderBy('created_at', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookingModel.fromFirestore(doc))
            .toList());
  }

  /// Stream showtime for real-time seat availability
  Stream<ShowtimeModel> watchShowtime(String showtimeId) {
    return _firestore
        .collection('showtimes')
        .doc(showtimeId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        throw Exception('Showtime not found');
      }
      return ShowtimeModel.fromFirestore(doc);
    });
  }
}
