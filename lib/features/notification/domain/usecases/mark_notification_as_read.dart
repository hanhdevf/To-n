import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/notification/domain/repositories/notification_repository.dart';

/// UseCase to mark a notification as read
class MarkNotificationAsRead implements UseCase<void, String> {
  final NotificationRepository repository;

  MarkNotificationAsRead(this.repository);

  @override
  Future<Either<Failure, void>> call(String notificationId) {
    return repository.markAsRead(notificationId);
  }
}
