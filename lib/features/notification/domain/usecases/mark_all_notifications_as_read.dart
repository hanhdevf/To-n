import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/notification/domain/repositories/notification_repository.dart';

/// UseCase to mark all notifications as read
class MarkAllNotificationsAsRead implements UseCase<void, NoParams> {
  final NotificationRepository repository;

  MarkAllNotificationsAsRead(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.markAllAsRead();
  }
}
