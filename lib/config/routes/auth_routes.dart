import 'package:go_router/go_router.dart';
import 'package:galaxymob/core/di/injection.dart';
import 'package:galaxymob/config/routes/heplers/route_wrappers.dart';
import 'package:galaxymob/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:galaxymob/features/auth/presentation/pages/login_page.dart';
import 'package:galaxymob/features/auth/presentation/pages/register_page.dart';
import 'package:galaxymob/features/admin/presentation/pages/admin_seeding_page.dart';

/// Authentication and admin routes that live outside the main shell.
final List<GoRoute> authRoutes = [
  GoRoute(
    path: '/login',
    name: 'login',
    builder: (context, state) =>
        withBloc<AuthBloc>((_) => getIt<AuthBloc>(), const LoginPage()),
  ),
  GoRoute(
    path: '/register',
    name: 'register',
    builder: (context, state) =>
        withBloc<AuthBloc>((_) => getIt<AuthBloc>(), const RegisterPage()),
  ),
  // Admin Seeding Page (dev-only)
   GoRoute(
    path: '/admin/seeding',
    name: 'adminSeeding',
    builder: (context, state) => AdminSeedingPage(),
  ),
];
