import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/core/di/injection.dart';
import 'package:galaxymob/core/widgets/main_navigation_shell.dart';
import 'package:galaxymob/config/routes/route_wrappers.dart';
import 'package:galaxymob/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:galaxymob/features/auth/presentation/pages/profile_page.dart';
import 'package:galaxymob/features/booking/presentation/bloc/ticket_bloc.dart';
import 'package:galaxymob/features/booking/presentation/bloc/ticket_event.dart';
import 'package:galaxymob/features/booking/presentation/pages/my_tickets_page.dart';
import 'package:galaxymob/features/movies/presentation/bloc/genre_bloc.dart';
import 'package:galaxymob/features/movies/presentation/bloc/genre_event.dart';
import 'package:galaxymob/features/movies/presentation/bloc/movie_bloc.dart';
import 'package:galaxymob/features/movies/presentation/pages/search_page.dart';
import 'package:galaxymob/features/home/presentation/pages/home_page.dart';

/// Shell route that powers the main bottom navigation (home/search/tickets/profile).
final ShellRoute mainShellRoute = ShellRoute(
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
      builder: (context, state) =>
          withBloc<MovieBloc>((_) => getIt<MovieBloc>(), const HomePage()),
    ),
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => withMultiBloc(
        [
          BlocProvider(
            create: (context) => getIt<MovieBloc>(),
          ),
          BlocProvider(
            create: (context) => getIt<GenreBloc>()..add(const LoadGenresEvent()),
          ),
        ],
        const SearchPage(),
      ),
    ),
    GoRoute(
      path: '/tickets',
      name: 'tickets',
      builder: (context, state) => withBloc<TicketBloc>(
        (_) => getIt<TicketBloc>()..add(const LoadTicketsEvent()),
        const MyTicketsPage(),
      ),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) =>
          withBloc<AuthBloc>((_) => getIt<AuthBloc>(), const ProfilePage()),
    ),
  ],
);
