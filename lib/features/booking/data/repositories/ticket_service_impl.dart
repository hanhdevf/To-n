import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/booking/domain/entities/ticket.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';
import 'package:galaxymob/features/booking/domain/repositories/ticket_service.dart';

/// Ticket service implementation using Hive for local storage
class TicketServiceImpl implements TicketService {
  static const String _boxName = 'tickets';
  final _uuid = const Uuid();

  Future<Box> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox(_boxName);
    }
    return Hive.box(_boxName);
  }

  @override
  Future<Either<Failure, Ticket>> generateTicket(Booking booking) async {
    try {
      final ticketId = 'TICKET-${_uuid.v4().substring(0, 12).toUpperCase()}';
      final qrData = Ticket.generateQRData(booking);
      final now = DateTime.now();

      // Ticket expires 30 minutes after showtime
      final expiresAt = booking.showtime.add(const Duration(minutes: 30));

      final ticket = Ticket(
        id: ticketId,
        booking: booking,
        qrData: qrData,
        generatedAt: now,
        expiresAt: expiresAt,
      );

      return Right(ticket);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveTicket(Ticket ticket) async {
    try {
      final box = await _getBox();

      // Convert ticket to map for storage
      final ticketMap = {
        'id': ticket.id,
        'bookingId': ticket.booking.id,
        'qrData': ticket.qrData,
        'generatedAt': ticket.generatedAt.toIso8601String(),
        'expiresAt': ticket.expiresAt.toIso8601String(),
        'isUsed': ticket.isUsed,
        'usedAt': ticket.usedAt?.toIso8601String(),
        // Store booking data
        'booking': {
          'id': ticket.booking.id,
          'movieId': ticket.booking.movieId,
          'movieTitle': ticket.booking.movieTitle,
          'cinemaId': ticket.booking.cinemaId,
          'cinemaName': ticket.booking.cinemaName,
          'showtimeId': ticket.booking.showtimeId,
          'showtime': ticket.booking.showtime.toIso8601String(),
          'totalPrice': ticket.booking.totalPrice,
          'userName': ticket.booking.userName,
          'userEmail': ticket.booking.userEmail,
          'userPhone': ticket.booking.userPhone,
          'status': ticket.booking.status.toString(),
          'paymentMethod': ticket.booking.paymentMethod.toString(),
          'transactionId': ticket.booking.transactionId,
          'createdAt': ticket.booking.createdAt.toIso8601String(),
          'formattedSeats': ticket.booking.formattedSeats,
          'ticketCount': ticket.booking.ticketCount,
        },
      };

      await box.put(ticket.id, ticketMap);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Ticket>>> getUserTickets() async {
    try {
      final box = await _getBox();
      final tickets = <Ticket>[];

      for (var key in box.keys) {
        final ticketMap = box.get(key) as Map?;
        if (ticketMap != null) {
          // Note: This is simplified - in real app, we'd need proper
          // serialization/deserialization with full Booking reconstruction
          // For now, we'll handle this in the BLoC layer
          tickets.add(_mapToTicket(ticketMap));
        }
      }

      // Sort by generated date, newest first
      tickets.sort((a, b) => b.generatedAt.compareTo(a.generatedAt));

      return Right(tickets);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Ticket>> getTicketById(String ticketId) async {
    try {
      final box = await _getBox();
      final ticketMap = box.get(ticketId) as Map?;

      if (ticketMap == null) {
        return Left(CacheFailure('Ticket not found'));
      }

      return Right(_mapToTicket(ticketMap));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTicket(String ticketId) async {
    try {
      final box = await _getBox();
      await box.delete(ticketId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  // Helper method to convert map to Ticket
  // Note: Simplified version - proper implementation would use freezed/json_serializable
  Ticket _mapToTicket(Map ticketMap) {
    final bookingMap = ticketMap['booking'] as Map;

    final booking = Booking(
      id: bookingMap['id'],
      movieId: bookingMap['movieId'],
      movieTitle: bookingMap['movieTitle'],
      cinemaId: bookingMap['cinemaId'],
      cinemaName: bookingMap['cinemaName'],
      showtimeId: bookingMap['showtimeId'],
      showtime: DateTime.parse(bookingMap['showtime']),
      selectedSeats: [], // Simplified - seats not reconstructed
      totalPrice: bookingMap['totalPrice'],
      userName: bookingMap['userName'],
      userEmail: bookingMap['userEmail'],
      userPhone: bookingMap['userPhone'],
      status: _parseBookingStatus(bookingMap['status']),
      paymentMethod: _parsePaymentMethod(bookingMap['paymentMethod']),
      transactionId: bookingMap['transactionId'],
      createdAt: DateTime.parse(bookingMap['createdAt']),
    );

    return Ticket(
      id: ticketMap['id'],
      booking: booking,
      qrData: ticketMap['qrData'],
      generatedAt: DateTime.parse(ticketMap['generatedAt']),
      expiresAt: DateTime.parse(ticketMap['expiresAt']),
      isUsed: ticketMap['isUsed'],
      usedAt: ticketMap['usedAt'] != null
          ? DateTime.parse(ticketMap['usedAt'])
          : null,
    );
  }

  BookingStatus _parseBookingStatus(String status) {
    return BookingStatus.values.firstWhere(
      (e) => e.toString() == status,
      orElse: () => BookingStatus.pending,
    );
  }

  PaymentMethod _parsePaymentMethod(String method) {
    return PaymentMethod.values.firstWhere(
      (e) => e.toString() == method,
      orElse: () => PaymentMethod.creditCard,
    );
  }
}
