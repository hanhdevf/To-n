import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:galaxymob/config/theme/app_colors.dart';
import 'package:galaxymob/config/theme/app_dimens.dart';
import 'package:galaxymob/config/theme/app_text_styles.dart';
import 'package:galaxymob/features/notification/domain/entities/notification_entity.dart';

/// Card widget for displaying a single notification
class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback? onTap;
  final VoidCallback? onMarkAsRead;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onMarkAsRead,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spacing12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: InkWell(
            onTap: () {
              if (!notification.isRead && onMarkAsRead != null) {
                onMarkAsRead!();
              }
              onTap?.call();
            },
            borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                border: Border(
                  left: BorderSide(
                    color: notification.isRead
                        ? Colors.transparent
                        : AppColors.primary,
                    width: 4,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.spacing16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon based on type
                    _buildIcon(),
                    const SizedBox(width: AppDimens.spacing12),
                    // Content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  notification.title,
                                  style: AppTextStyles.h4.copyWith(
                                    fontWeight: notification.isRead
                                        ? FontWeight.normal
                                        : FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (!notification.isRead)
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: AppDimens.spacing4),
                          Text(
                            notification.message,
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: AppDimens.spacing8),
                          Text(
                            _formatTimeAgo(notification.createdAt),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case NotificationType.promo:
        iconData = Icons.local_offer;
        iconColor = AppColors.warning;
        break;
      case NotificationType.booking:
        iconData = Icons.confirmation_number;
        iconColor = AppColors.success;
        break;
      case NotificationType.system:
        iconData = Icons.info_outline;
        iconColor = AppColors.info;
        break;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimens.radiusSmall),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 22,
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
