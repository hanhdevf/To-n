import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/features/notification/data/datasources/mock_notification_data_source.dart';
import 'package:galaxymob/features/notification/domain/entities/notification_entity.dart';
import 'package:galaxymob/features/notification/domain/repositories/notification_repository.dart';

/// Implementation of NotificationRepository using mock data source
class NotificationRepositoryImpl implements NotificationRepository {
  final MockNotificationDataSource dataSource;

  NotificationRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final notifications = await dataSource.getNotifications();
      return Right(notifications);
    } catch (e) {
      return Left(
          ServerFailure('Failed to load notifications: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      await dataSource.markAsRead(notificationId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(
          'Failed to mark notification as read: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await dataSource.markAllAsRead();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(
          'Failed to mark all notifications as read: ${e.toString()}'));
    }
  }
}
