import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFFF27A1A);
  static const Color accent = Color(0xFFF5A623);
  static const Color background = Color(0xFFFDF7F0);
  static const Color card = Color(0xFFF7EFE6);
  static const Color border = Color(0xFFE6D8C8);
  static const Color muted = Color(0xFFEFE4D6);
  static const Color mutedText = Color(0xFF7B6E62);
  static const Color foreground = Color(0xFF3B2F25);
  static const Color destructive = Color(0xFFE34B4B);

  static ThemeData lightTheme() {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: primary,
        secondary: accent,
        surface: card,
        background: background,
        error: destructive,
        onPrimary: Colors.white,
        onSecondary: foreground,
        onSurface: foreground,
        onBackground: foreground,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        backgroundColor: background,
        foregroundColor: foreground,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        color: card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: border),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.6),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
