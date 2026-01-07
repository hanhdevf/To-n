import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/core/di/injection.dart';
import 'package:galaxymob/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:galaxymob/features/notification/presentation/bloc/notification_event.dart';
import 'package:galaxymob/features/notification/presentation/pages/notification_page.dart';

/// Notification route (outside shell).
final List<GoRoute> notificationRoutes = [
  GoRoute(
    path: '/notifications',
    name: 'notifications',
    builder: (context, state) => BlocProvider(
      create: (context) =>
          getIt<NotificationBloc>()..add(const LoadNotificationsEvent()),
      child: const NotificationPage(),
    ),
  ),
];
