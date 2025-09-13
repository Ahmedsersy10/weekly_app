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

  // Light Theme Background Colors
  static const Color background = Color(0xFFF8F9FA); // Light gray/off-white
  static const Color backgroundSecondary = Color(0xFFE9ECEF); // Slightly darker gray
  static const Color surface = Color(0xFFFFFFFF); // Pure white for cards/surfaces

  // Light Theme Text Colors - WCAG Compliant
  static const Color textPrimary = Color(0xFF2C3E50); // Dark slate for primary text
  static const Color textSecondary = Color(0xFF6C757D); // Medium gray for secondary text
  static const Color textTertiary = Color(0xFFADB5BD); // Light gray for tertiary text
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White text on primary background
  static const Color textOnAccent = Color(0xFFFFFFFF); // White text on accent background

  // Dark Theme Background Colors
  static const Color darkBackground = Color(0xFF121212); // Material Design dark background
  static const Color darkBackgroundSecondary = Color(0xFF1E1E1E); // Slightly lighter dark
  static const Color darkSurface = Color(0xFF1F1F1F); // Dark surface for cards
  static const Color darkSurfaceVariant = Color(0xFF2D2D2D); // Variant dark surface

  // Dark Theme Text Colors - WCAG Compliant
  static const Color darkTextPrimary = Color(0xFFE1E1E1); // Light gray for primary text
  static const Color darkTextSecondary = Color(0xFFB3B3B3); // Medium gray for secondary text
  static const Color darkTextTertiary = Color(0xFF8A8A8A); // Darker gray for tertiary text
  static const Color darkTextOnPrimary = Color(0xFFFFFFFF); // White text on primary background
  static const Color darkTextOnSurface = Color(0xFFE1E1E1); // Light text on dark surface

  // Status Colors (work for both themes)
  static const Color success = Color(0xFF4CAF50); // Material Green
  static const Color warning = Color(0xFFFF9800); // Material Orange
  static const Color error = Color(0xFFF44336); // Material Red
  static const Color info = Color(0xFF2196F3); // Material Blue

  // Dark Theme Status Colors (enhanced contrast)
  static const Color darkSuccess = Color(0xFF66BB6A); // Lighter green for dark theme
  static const Color darkWarning = Color(0xFFFFB74D); // Lighter orange for dark theme
  static const Color darkError = Color(0xFFEF5350); // Lighter red for dark theme
  static const Color darkInfo = Color(0xFF42A5F5); // Lighter blue for dark theme

  // Neutral Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);


  // Light Theme Gradient Colors
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

  // Dark Theme Gradient Colors
  static const LinearGradient darkPrimaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primary],
  );

  static const LinearGradient darkAccentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accentDark, accent],
  );

  static const LinearGradient darkSurfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkSurface, darkSurfaceVariant],
  );
}
