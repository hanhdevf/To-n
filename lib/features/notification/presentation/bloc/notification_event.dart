import 'package:equatable/equatable.dart';

/// Base class for notification events
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

/// Load all notifications
class LoadNotificationsEvent extends NotificationEvent {
  const LoadNotificationsEvent();
}

/// Mark a specific notification as read
class MarkAsReadEvent extends NotificationEvent {
  final String notificationId;

  const MarkAsReadEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

/// Mark all notifications as read
class MarkAllAsReadEvent extends NotificationEvent {
  const MarkAllAsReadEvent();
}
