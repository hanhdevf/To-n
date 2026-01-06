import 'package:equatable/equatable.dart';

/// Types of notifications
enum NotificationType {
  promo,
  booking,
  system,
}

/// Notification entity representing a single notification
class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime createdAt;
  final bool isRead;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object?> get props => [id, title, message, type, createdAt, isRead];

  @override
  String toString() =>
      'NotificationEntity(id: $id, title: $title, type: $type, isRead: $isRead)';
}
