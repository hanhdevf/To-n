import 'package:galaxymob/features/notification/domain/entities/notification_entity.dart';

/// Mock data source for notifications
/// Returns sample notifications for demonstration
class MockNotificationDataSource {
  // In-memory storage for notifications
  final List<NotificationEntity> _notifications = [
    NotificationEntity(
      id: '1',
      title: '🎉 Weekend Special!',
      message:
          'Get 50% off on all movie tickets this weekend. Use code WEEKEND50 at checkout.',
      type: NotificationType.promo,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    NotificationEntity(
      id: '2',
      title: 'Booking Confirmed',
      message:
          'Your booking for "Avengers: Endgame" at Galaxy Cinema on Jan 10, 7:30 PM has been confirmed.',
      type: NotificationType.booking,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
    ),
    NotificationEntity(
      id: '3',
      title: 'New Movies This Week',
      message:
          'Check out the latest releases including "Dune: Part Two" and "Kung Fu Panda 4".',
      type: NotificationType.system,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationEntity(
      id: '4',
      title: '🎬 Premiere Alert',
      message:
          'Be the first to watch "Spider-Man: Beyond the Spider-Verse" – Premiere tickets available now!',
      type: NotificationType.promo,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      isRead: false,
    ),
    NotificationEntity(
      id: '5',
      title: 'Payment Successful',
      message:
          'Your payment of 250,000 VND for booking #GX12345 was successful.',
      type: NotificationType.booking,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
    NotificationEntity(
      id: '6',
      title: 'App Update Available',
      message:
          'A new version of GalaxyMov is available. Update now for the best experience.',
      type: NotificationType.system,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
    NotificationEntity(
      id: '7',
      title: '🍿 Free Popcorn!',
      message:
          'Book any movie today and get a free medium popcorn. Limited time offer!',
      type: NotificationType.promo,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      isRead: true,
    ),
  ];

  /// Get all notifications
  Future<List<NotificationEntity>> getNotifications() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    // Return sorted by createdAt descending (newest first)
    final sorted = List<NotificationEntity>.from(_notifications)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  /// Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    await Future.delayed(const Duration(milliseconds: 300));
    for (int i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
  }

  /// Get unread count
  int get unreadCount => _notifications.where((n) => !n.isRead).length;
}
