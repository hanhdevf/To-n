import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/core/di/injection.dart';
import 'package:galaxymob/features/booking/domain/entities/ticket.dart';
import 'package:galaxymob/config/routes/heplers/route_args.dart';
import 'package:galaxymob/config/routes/heplers/route_wrappers.dart';
import 'package:galaxymob/features/booking/presentation/bloc/booking_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/payment_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/seat_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/seat_event.dart';
import 'package:galaxymob/features/booking/presentation/pages/booking_summary_page.dart';
import 'package:galaxymob/features/booking/presentation/pages/my_bookings_page.dart';
import 'package:galaxymob/features/booking/presentation/pages/seat_selection_page.dart';
import 'package:galaxymob/features/booking/presentation/pages/ticket_detail_page.dart';


/// Booking-related routes (outside shell).
final List<GoRoute> bookingRoutes = [
  GoRoute(
    path: '/my-bookings',
    name: 'myBookings',
    builder: (context, state) => const MyBookingsPage(),
  ),
  GoRoute(
    path: '/booking/seats',
    name: 'seatSelection',
    builder: (context, state) {
      final extra = state.extra as SeatSelectionArgs;
      return withBloc<SeatBloc>(
        (_) => getIt<SeatBloc>()
          ..add(
            LoadSeatLayoutEvent(
              showtimeId: extra.showtimeId,
              basePrice: extra.basePrice,
            ),
          ),
        SeatSelectionPage(
          showtimeId: extra.showtimeId,
          movieTitle: extra.movieTitle,
          cinemaName: extra.cinemaName,
          showtime: extra.showtime,
          showtimeDateTime: extra.showtimeDateTime,
          basePrice: extra.basePrice,
        ),
      );
    },
  ),
  GoRoute(
    path: '/booking/summary',
    name: 'bookingSummary',
    pageBuilder: (context, state) {
      final extra = state.extra as BookingSummaryArgs;
      return MaterialPage(
        child: withMultiBloc(
          [
            BlocProvider(
              create: (context) => getIt<PaymentBloc>(),
            ),
            BlocProvider(
              create: (context) => getIt<BookingBloc>(),
            ),
          ],
          BookingSummaryPage(
            movieTitle: extra.movieTitle,
            cinemaName: extra.cinemaName,
            showtime: extra.showtime,
            showtimeDateTime: extra.showtimeDateTime,
            selectedSeats: extra.selectedSeats,
            totalPrice: extra.totalPrice,
            movieId: extra.movieId,
            cinemaId: extra.cinemaId,
            showtimeId: extra.showtimeId,
          ),
        ),
      );
    },
  ),
  GoRoute(
    path: '/ticket-detail',
    name: 'ticketDetail',
    builder: (context, state) {
      final ticket = state.extra as Ticket;
      return TicketDetailPage(ticket: ticket);
    },
  ),
];
