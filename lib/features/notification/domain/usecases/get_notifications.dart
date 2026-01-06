import 'package:dartz/dartz.dart';
import 'package:galaxymob/core/error/failures.dart';
import 'package:galaxymob/core/usecase/usecase.dart';
import 'package:galaxymob/features/notification/domain/entities/notification_entity.dart';
import 'package:galaxymob/features/notification/domain/repositories/notification_repository.dart';

/// UseCase to get all notifications
class GetNotifications implements UseCase<List<NotificationEntity>, NoParams> {
  final NotificationRepository repository;

  GetNotifications(this.repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(NoParams params) {
    return repository.getNotifications();
  }
}
