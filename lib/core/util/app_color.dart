import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Deep Slate/Blue
  static const Color primary = Color(0xFF2C3E50); // Deep slate blue
  static const Color primaryLight = Color(0xFF34495E); // Lighter slate
  static const Color primaryDark = Color(0xFF1A252F); // Darker slate

  // Accent Colors - Teal
  static const Color accent = Color(0xFF16A085); // Teal
  static const Color accentLight = Color(0xFF1ABC9C); // Light teal
  static const Color accentDark = Color(0xFF138D75); // Dark teal

  // Background Colors
  static const Color background = Color(0xFFF8F9FA); // Light gray/off-white
  static const Color backgroundSecondary = Color(0xFFE9ECEF); // Slightly darker gray
  static const Color surface = Color(0xFFFFFFFF); // Pure white for cards/surfaces

  // Text Colors - WCAG Compliant
  static const Color textPrimary = Color(0xFF2C3E50); // Dark slate for primary text
  static const Color textSecondary = Color(0xFF6C757D); // Medium gray for secondary text
  static const Color textTertiary = Color(0xFFADB5BD); // Light gray for tertiary text
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White text on primary background
  static const Color textOnAccent = Color(0xFFFFFFFF); // White text on accent background

  // Status Colors
  static const Color success = Color(0xFF28A745); // Green
  static const Color warning = Color(0xFFFFC107); // Amber
  static const Color error = Color(0xFFDC3545); // Red
  static const Color info = Color(0xFF17A2B8); // Blue

  // Neutral Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);


  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentLight],
  );
}
