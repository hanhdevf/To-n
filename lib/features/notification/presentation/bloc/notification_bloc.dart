import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/notification/domain/usecases/get_notifications.dart';
import 'package:galaxymob/features/notification/domain/usecases/mark_all_notifications_as_read.dart';
import 'package:galaxymob/features/notification/domain/usecases/mark_notification_as_read.dart';
import 'package:galaxymob/features/notification/presentation/bloc/notification_event.dart';
import 'package:galaxymob/features/notification/presentation/bloc/notification_state.dart';

/// BLoC for managing notification state
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotifications getNotifications;
  final MarkNotificationAsRead markNotificationAsRead;
  final MarkAllNotificationsAsRead markAllNotificationsAsRead;

  NotificationBloc({
    required this.getNotifications,
    required this.markNotificationAsRead,
    required this.markAllNotificationsAsRead,
  }) : super(const NotificationInitial()) {
    on<LoadNotificationsEvent>(_onLoadNotifications);
    on<MarkAsReadEvent>(_onMarkAsRead);
    on<MarkAllAsReadEvent>(_onMarkAllAsRead);
  }

  Future<void> _onLoadNotifications(
    LoadNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    emit(const NotificationLoading());

    final result = await getNotifications(NoParams());

    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (notifications) {
        final unreadCount = notifications.where((n) => !n.isRead).length;
        emit(NotificationLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
        ));
      },
    );
  }

  Future<void> _onMarkAsRead(
    MarkAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;

      // Optimistic update
      final updatedNotifications = currentState.notifications.map((n) {
        if (n.id == event.notificationId) {
          return n.copyWith(isRead: true);
        }
        return n;
      }).toList();

      final newUnreadCount =
          updatedNotifications.where((n) => !n.isRead).length;

      emit(currentState.copyWith(
        notifications: updatedNotifications,
        unreadCount: newUnreadCount,
      ));

      // Perform actual update
      await markNotificationAsRead(event.notificationId);
    }
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsReadEvent event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;

      // Optimistic update
      final updatedNotifications = currentState.notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();

      emit(currentState.copyWith(
        notifications: updatedNotifications,
        unreadCount: 0,
      ));

      // Perform actual update
      await markAllNotificationsAsRead(NoParams());
    }
  }
}
