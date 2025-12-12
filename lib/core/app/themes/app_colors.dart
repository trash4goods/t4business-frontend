// core/app/themes/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors
  static const Color primary = Color.fromRGBO(0, 132, 67, 1);
  static const Color primaryDark = Color.fromRGBO(79, 151, 117, 1);
  static const Color primaryLight = Color.fromRGBO(163, 192, 162, 1);

  // Website Primary Colors
  static const Color yellowLight = Color(0xFFFAF5E5);
  static const Color yellowDark = Color(0xFFF3F89B);
  static const Color darkGreen = Color(0xFF065930);
  static const Color darkLightGreen = Color(0xFF668964);
  static const Color green = Color(0xFF82B378);
  static const Color lightGreen = Color(0xFFA3C1A2);

  // Enhanced contrast colors for better visibility
  static const Color surfaceElevated = Color(0xFFFAFAFA);
  static const Color surfaceElevatedHigh = Color(0xFFF5F5F5);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color inputBorder = Color(0xFFD1D5DB);
  static const Color inputBorderFocused = Color(0xFF10B981);

  // Form field colors
  static const Color fieldBackground = Color(0xFFFFFFFF);
  static const Color fieldBorder = Color(0xFFE5E7EB);
  static const Color fieldBorderFocused = Color(0xFF059669);
  static const Color fieldText = Color(0xFF111827);
  static const Color fieldPlaceholder = Color(0xFF9CA3AF);

  // Preview panel colors
  static const Color previewBackground = Color(0xFFF9FAFB);
  static const Color previewBorder = Color(0xFFE5E7EB);
  static const Color previewShadow = Color(0x0A000000);

  // Secondary Colors
  static const Color secondary = Color(0xFF4CAF50);
  static const Color secondaryDark = Color(0xFF388E3C);
  static const Color secondaryLight = Color(0xFF81C784);

  // Travel Connect Blue Theme Colors
  static const Color blueGradientStart = Color(0xFF3B82F6);
  static const Color blueGradientEnd = Color(0xFF6366F1);
  static const Color blueDark = Color(0xFF2563EB);
  static const Color indigo = Color(0xFF4F46E5);
  static const Color lightBlue = Color(0xFFDDEAFF);
  static const Color mapDotBlue = Color(0xFF2563EB);

  // Light theme colors for new design
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightTextPrimary = Color(0xFF1E293B);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // Background Colors
  static const Color backgroundGradientStart = Color.fromRGBO(22, 28, 30, 1);
  static const Color backgroundGradientEnd = Color.fromRGBO(33, 37, 38, 1);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;

  // Text Colors
  static const Color textLight = Color(0xFFE5E5E5);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);
  static const Color background = Color(0xFFFAF5E5);
  static const Color surface = Colors.white;
  static const Color onPrimary = Colors.white;
  static const Color onSurface = Color(0xFF212121);
  static const Color grey = Color(0xFF757575);
  static const Color lightGrey = Color(0xFFE0E0E0);

  // Modern shadcn-inspired color palette
  static const Color foreground = Color(0xFF0A0A0A);
  static const Color card = Color(0xFFFFFFFF);
  static const Color cardForeground = Color(0xFF0A0A0A);
  static const Color popover = Color(0xFFFFFFFF);
  static const Color popoverForeground = Color(0xFF0A0A0A);
  static const Color primaryForeground = Color(0xFFFAFAFA);
  static const Color secondaryForeground = Color(0xFF171717);
  static const Color muted = Color(0xFFF5F5F5);
  static const Color mutedForeground = Color(0xFF737373);
  static const Color accent = Color(0xFFF5F5F5);
  static const Color accentForeground = Color(0xFF171717);
  static const Color destructive = Color(0xFFEF4444);
  static const Color destructiveForeground = Color(0xFFFEFEFE);
  static const Color border = Color(0xFFE5E5E5);
  static const Color input = Color(0xFFE5E5E5);
  static const Color ring = Color(0xFF171717);
  static const Color outline = Color(0xFFE0E0E0);
  static const Color outlineVariant = Color(0xFFBDBDBD);

  // Accent colors
  static const Color accentLight = Color(0xFF60A5FA);
  static const Color accentDark = Color(0xFF2563EB);

  // Success colors
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);

  // Warning colors
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);

  // Error colors
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);

  // Neutral colors
  static const Color surfaceContainer = Color(0xFFF8FAFC);
  static const Color surfaceContainerHigh = Color(0xFFF1F5F9);

  // Text colors
  static const Color onBackground = Color(0xFF0F172A);
  static const Color onSurfaceVariant = Color(0xFF64748B);
  static const Color onSurfaceSecondary = Color(0xFF94A3B8);

  // Special colors
  static const Color shadow = Color(0x0A000000);
  static const Color overlay = Color(0x80000000);

  // Interactive states
  static const Color hover = Color(0xFFF8FAFC);
  static const Color pressed = Color(0xFFF1F5F9);
  static const Color focus = Color(0x1A3B82F6);

  // Status colors
  static const Color online = Color(0xFF10B981);
  static const Color offline = Color(0xFF6B7280);
  static const Color draft = Color(0xFFF59E0B);
  static const Color published = Color(0xFF3B82F6);

  // Chart colors
  static const List<Color> chartColors = [
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
  ];

  // Border Colors
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color dividerColor = Color(0xFFBDBDBD);

  // Shadow Colors
  static const Color shadowColor = Color(0x1A000000);

  /// Tertiary background color for nested elements
  static const Color backgroundColorTertiary = Color.fromRGBO(45, 50, 52, 1);

  /// Secondary background color for cards, dialogs, etc.
  static const Color backgroundColorSecondary = Color.fromRGBO(37, 42, 43, 1);

  /// Background color for the Error Snackbars
  static const Color snackBarDangerBackgroundColor = Color.fromRGBO(
    208,
    80,
    106,
    1.0,
  );

  /// Background color for the Success Snackbars
  static const Color snackBarSuccessBackgroundColor = Color.fromRGBO(
    79,
    151,
    117,
    1.0,
  );

  /// Background color for the Info Snackbars
  static const Color snackBarInfoBackgroundColor = Color.fromRGBO(
    24,
    174,
    213,
    1.0,
  );

  /// Background color for the Warning Snackbars
  static const Color snackBarWarningBackgroundColor = Color.fromRGBO(
    245,
    180,
    50,
    1.0,
  );
}
