import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/notification/domain/entities/notification_entity.dart';

/// Repository interface for notification operations
abstract class NotificationRepository {
  /// Get all notifications for the current user
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();

  /// Mark a specific notification as read
  Future<Either<Failure, void>> markAsRead(String notificationId);

  /// Mark all notifications as read
  Future<Either<Failure, void>> markAllAsRead();
}
