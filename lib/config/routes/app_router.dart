import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/core/di/injection.dart';
import 'package:galaxymob/core/widgets/main_navigation_shell.dart';
import 'package:galaxymob/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:galaxymob/features/auth/presentation/pages/login_page.dart';
import 'package:galaxymob/features/auth/presentation/pages/register_page.dart';
import 'package:galaxymob/features/auth/presentation/pages/profile_page.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_bloc.dart';
import 'package:galaxymob/features/home/presentation/pages/home_page.dart';
import 'package:galaxymob/features/movies/presentation/pages/movie_detail_page.dart';
import 'package:galaxymob/features/movies/presentation/pages/search_page.dart';
import 'package:galaxymob/features/cinema/presentation/bloc/cinema_bloc.dart';
import 'package:galaxymob/features/cinema/presentation/pages/showtime_selection_page.dart';
import 'package:galaxymob/features/booking/presentation/bloc/seat_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/seat_event.dart';
import 'package:galaxymob/features/booking/presentation/bloc/payment_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/ticket_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/ticket_event.dart';
import 'package:galaxymob/features/booking/presentation/pages/seat_selection_page.dart';
import 'package:galaxymob/features/booking/presentation/pages/booking_summary_page.dart';
import 'package:galaxymob/features/booking/presentation/pages/ticket_page.dart';
import 'package:galaxymob/features/booking/presentation/pages/my_tickets_page.dart';
import 'package:galaxymob/features/booking/presentation/pages/my_bookings_page.dart';
import 'package:galaxymob/features/booking/domain/entities/booking.dart';

/// Application router configuration using go_router
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    debugLogDiagnostics: true,
    routes: [
      // Auth Routes (outside main shell)
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthBloc>(),
          child: const LoginPage(),
        ),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthBloc>(),
          child: const RegisterPage(),
        ),
      ),

      // Main Shell with Bottom Navigation
      ShellRoute(
        builder: (context, state, child) {
          int currentIndex = 0;
          final location = state.uri.toString();
          if (location.startsWith('/search')) {
            currentIndex = 1;
          } else if (location.startsWith('/tickets')) {
            currentIndex = 2;
          } else if (location.startsWith('/profile')) {
            currentIndex = 3;
          }

          return MainNavigationShell(
            currentIndex: currentIndex,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => BlocProvider(
              create: (context) => getIt<MovieBloc>(),
              child: const HomePage(),
            ),
          ),
          GoRoute(
            path: '/search',
            name: 'search',
            builder: (context, state) => const SearchPage(),
          ),
          GoRoute(
            path: '/tickets',
            name: 'tickets',
            builder: (context, state) => BlocProvider(
              create: (context) =>
                  getIt<TicketBloc>()..add(const LoadTicketsEvent()),
              child: const MyTicketsPage(),
            ),
          ),
          GoRoute(
            path: '/profile',
            name: 'profile',
            builder: (context, state) => BlocProvider(
              create: (context) => getIt<AuthBloc>(),
              child: const ProfilePage(),
            ),
          ),
        ],
      ),

      // My Bookings Route (outside shell)
      GoRoute(
        path: '/my-bookings',
        name: 'myBookings',
        builder: (context, state) => const MyBookingsPage(),
      ),

      // Movie Detail Route (outside shell)
      GoRoute(
        path: '/movie/:id',
        name: 'movieDetail',
        builder: (context, state) {
          final movieId = int.parse(state.pathParameters['id']!);
          return MovieDetailPage(movieId: movieId);
        },
      ),

      // Showtime Selection Route
      GoRoute(
        path: '/movie/:id/showtimes',
        name: 'showtimeSelection',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => getIt<CinemaBloc>(),
            child: ShowtimeSelectionPage(
              movieId: extra['movieId'],
              movieTitle: extra['movieTitle'],
            ),
          );
        },
      ),

      // Seat Selection Route
      GoRoute(
        path: '/booking/seats',
        name: 'seatSelection',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => getIt<SeatBloc>()
              ..add(LoadSeatLayoutEvent(
                showtimeId: extra['showtimeId'],
                basePrice: extra['basePrice'],
              )),
            child: SeatSelectionPage(
              showtimeId: extra['showtimeId'],
              movieTitle: extra['movieTitle'],
              cinemaName: extra['cinemaName'],
              showtime: extra['showtime'],
              basePrice: extra['basePrice'],
            ),
          );
        },
      ),

      // Booking Summary Route
      GoRoute(
        path: '/booking/summary',
        name: 'bookingSummary',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => getIt<PaymentBloc>(),
            child: BookingSummaryPage(
              movieTitle: extra['movieTitle'],
              cinemaName: extra['cinemaName'],
              showtime: extra['showtime'],
              selectedSeats: List<String>.from(extra['selectedSeats']),
              totalPrice: extra['totalPrice'],
              movieId: extra['movieId'],
              cinemaId: extra['cinemaId'],
              showtimeId: extra['showtimeId'],
            ),
          );
        },
      ),

      // Ticket View Route
      GoRoute(
        path: '/ticket',
        name: 'ticketView',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return BlocProvider(
            create: (context) => getIt<TicketBloc>(),
            child: TicketPage(
              movieTitle: extra['movieTitle'],
              cinemaName: extra['cinemaName'],
              showtime: extra['showtime'],
              selectedSeats: List<String>.from(extra['selectedSeats']),
              totalPrice: extra['totalPrice'],
              userName: extra['userName'],
              userEmail: extra['userEmail'],
              userPhone: extra['userPhone'],
              transactionId: extra['transactionId'],
              paymentMethod: extra['paymentMethod'] as PaymentMethod,
            ),
          );
        },
      ),
    ],
    errorBuilder: (context, state) => const ErrorPage(),
  );
}

/// Error Page
class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Page not found'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
