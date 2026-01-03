import 'dart:ui';

/// Application color palette following Dark Cinema Theme
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // Primary Colors
  static const Color primary = Color(0xFF6C63FF); // Electric Purple
  static const Color secondary = Color(0xFFFF6584); // Coral Pink
  static const Color background = Color(0xFF0F0F1E); // Deep Navy
  static const Color surface = Color(0xFF1A1A2E); // Slightly lighter

  // Text Colors
  static const Color textPrimary = Color(0xFFF5F5F7); // Almost White
  static const Color textSecondary = Color(0xFFB0B3C1); // Gray-Blue
  static const Color textTertiary = Color(0xFF6E7191); // Muted Gray

  // Semantic Colors
  static const Color success = Color(0xFF34D399); // Green (Available seats)
  static const Color error = Color(0xFFEF4444); // Red (Booked seats)
  static const Color warning = Color(0xFFFBBF24); // Amber (Selected seats)
  static const Color info = Color(0xFF3B82F6); // Blue (Notifications)

  // Additional
  static const Color divider = Color(0xFF2A2A3E);
  static const Color disabled = Color(0xFF4A4A5E);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // Gradient Colors
  static const Color gradientStart = Color(0xFF6C63FF);
  static const Color gradientEnd = Color(0xFF5A52D5);

  // Overlay Colors
  static const Color overlay = Color(0x80000000); // 50% black
  static const Color overlayLight = Color(0x40000000); // 25% black
}
