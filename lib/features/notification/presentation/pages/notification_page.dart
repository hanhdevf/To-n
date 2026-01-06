import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/core/widgets/shimmer_loading.dart';
import 'package:galaxymob/features/notification/domain/entities/notification_entity.dart';
import 'package:galaxymob/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:galaxymob/features/notification/presentation/bloc/notification_event.dart';
import 'package:galaxymob/features/notification/presentation/bloc/notification_state.dart';
import 'package:galaxymob/features/notification/presentation/widgets/notification_card.dart';

/// Notification center page
class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return _buildLoadingState();
          }

          if (state is NotificationError) {
            return _buildErrorState(context, state.message);
          }

          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return _buildEmptyState();
            }
            return _buildNotificationList(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Notifications',
        style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
      ),
      centerTitle: true,
      actions: [
        BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoaded && state.unreadCount > 0) {
              return TextButton(
                onPressed: () {
                  context
                      .read<NotificationBloc>()
                      .add(const MarkAllAsReadEvent());
                },
                child: Text(
                  'Mark all read',
                  style: AppTextStyles.body2.copyWith(color: AppColors.primary),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimens.spacing16),
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: AppDimens.spacing12),
        child: ShimmerLoading(
          child: ShimmerBox(
            width: double.infinity,
            height: 100,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spacing24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error.withValues(alpha: 0.7),
            ),
            const SizedBox(height: AppDimens.spacing16),
            Text(
              'Oops! Something went wrong',
              style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spacing8),
            Text(
              message,
              style:
                  AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spacing24),
            ElevatedButton.icon(
              onPressed: () {
                context
                    .read<NotificationBloc>()
                    .add(const LoadNotificationsEvent());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spacing24,
                  vertical: AppDimens.spacing12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
                ),
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spacing24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_outlined,
                size: 48,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: AppDimens.spacing24),
            Text(
              'No notifications yet',
              style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
            ),
            const SizedBox(height: AppDimens.spacing8),
            Text(
              'We\'ll notify you when there\'s something new!',
              style:
                  AppTextStyles.body2.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationList(
      BuildContext context, NotificationLoaded state) {
    // Group notifications by date
    final grouped = _groupNotificationsByDate(state.notifications);

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimens.spacing16),
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final group = grouped[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (index > 0) const SizedBox(height: AppDimens.spacing16),
            // Date header
            Padding(
              padding: const EdgeInsets.only(
                left: AppDimens.spacing4,
                bottom: AppDimens.spacing12,
              ),
              child: Text(
                group.label,
                style: AppTextStyles.overline.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Notifications in group
            ...group.notifications.map(
              (notification) => NotificationCard(
                notification: notification,
                onMarkAsRead: () {
                  context.read<NotificationBloc>().add(
                        MarkAsReadEvent(notification.id),
                      );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  List<_NotificationGroup> _groupNotificationsByDate(
      List<NotificationEntity> notifications) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final todayList = <NotificationEntity>[];
    final yesterdayList = <NotificationEntity>[];
    final earlierList = <NotificationEntity>[];

    for (final notification in notifications) {
      final notificationDate = DateTime(
        notification.createdAt.year,
        notification.createdAt.month,
        notification.createdAt.day,
      );

      if (notificationDate.isAtSameMomentAs(today)) {
        todayList.add(notification);
      } else if (notificationDate.isAtSameMomentAs(yesterday)) {
        yesterdayList.add(notification);
      } else {
        earlierList.add(notification);
      }
    }

    final groups = <_NotificationGroup>[];
    if (todayList.isNotEmpty) {
      groups.add(_NotificationGroup(label: 'Today', notifications: todayList));
    }
    if (yesterdayList.isNotEmpty) {
      groups.add(
          _NotificationGroup(label: 'Yesterday', notifications: yesterdayList));
    }
    if (earlierList.isNotEmpty) {
      groups.add(
          _NotificationGroup(label: 'Earlier', notifications: earlierList));
    }

    return groups;
  }
}

class _NotificationGroup {
  final String label;
  final List<NotificationEntity> notifications;

  _NotificationGroup({required this.label, required this.notifications});
}
