import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:galaxymob/config/theme/app_colors.dart';

/// Application typography system using Outfit font family
class AppTextStyles {
  AppTextStyles._(); // Private constructor to prevent instantiation

  // Base text style
  static TextStyle get _baseTextStyle =>
      GoogleFonts.outfit(color: AppColors.textPrimary);

  // Headings
  static TextStyle get h1 => _baseTextStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle get h2 => _baseTextStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static TextStyle get h3 => _baseTextStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static TextStyle get h4 => _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // Body Text
  static TextStyle get body1 => _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static TextStyle get body2 => _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textSecondary,
  );

  static TextStyle get body1Medium =>
      body1.copyWith(fontWeight: FontWeight.w500);

  static TextStyle get body2Medium =>
      body2.copyWith(fontWeight: FontWeight.w500);

  // Caption
  static TextStyle get caption => _baseTextStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: AppColors.textTertiary,
  );

  static TextStyle get captionMedium =>
      caption.copyWith(fontWeight: FontWeight.w500);

  // Button
  static TextStyle get button => _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.0,
  );

  static TextStyle get buttonSmall => button.copyWith(fontSize: 14);

  // Overline (Section headers, labels)
  static TextStyle get overline => _baseTextStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    height: 1.0,
    color: AppColors.textTertiary,
  );

  // Special styles
  static TextStyle get movieTitle => h3.copyWith(fontWeight: FontWeight.w700);

  static TextStyle get price =>
      h2.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700);

  static TextStyle get rating => body2Medium.copyWith(color: AppColors.warning);
}
