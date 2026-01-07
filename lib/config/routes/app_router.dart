import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/config/routes/auth_routes.dart';
import 'package:galaxymob/config/routes/booking_routes.dart';
import 'package:galaxymob/config/routes/movie_routes.dart';
import 'package:galaxymob/config/routes/notification_routes.dart';
import 'package:galaxymob/config/routes/shell_routes.dart';

/// Application router configuration using go_router
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    debugLogDiagnostics: true,
    routes: [
      ...authRoutes,
      mainShellRoute,
      ...bookingRoutes,
      ...notificationRoutes,
      ...movieRoutes,
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
