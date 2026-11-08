import 'package:flutter/material.dart';

/// Konfigurasi tema aplikasi untuk Light Mode dan Dark Mode.
/// Menggunakan Material 3 design system dengan custom color palette.
class AppTheme {
  // ─── Light Theme Colors ────────────────────────────────────────
  
  static const Color _lightPrimary = Color(0xFF673AB7); // Deep Purple
  static const Color _lightBackground = Colors.white;
  static const Color _lightSurface = Colors.white;
  static const Color _lightCardBackground = Colors.white;
  
  // ─── Dark Theme Colors ─────────────────────────────────────────
  
  static const Color _darkPrimary = Color(0xFF9575CD); // Lighter Purple
  static const Color _darkBackground = Color(0xFF121212);
  static const Color _darkSurface = Color(0xFF1E1E1E);
  static const Color _darkCardBackground = Color(0xFF2C2C2C);

  // ─── Light Theme ───────────────────────────────────────────────

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Poppins',
      
      colorScheme: ColorScheme.light(
        primary: _lightPrimary,
        secondary: Colors.deepPurpleAccent,
        surface: _lightSurface,
        background: _lightBackground,
        error: Colors.red.shade600,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.grey.shade800,
        onBackground: Colors.grey.shade800,
        onError: Colors.white,
      ),

      scaffoldBackgroundColor: _lightBackground,
      
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: _lightPrimary),
        titleTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _lightPrimary,
        ),
      ),

      cardTheme: CardTheme(
        color: _lightCardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightPrimary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _lightPrimary,
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _lightPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade600),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),

      iconTheme: IconThemeData(color: Colors.grey.shade600),
    );
  }

  // ─── Dark Theme ────────────────────────────────────────────────

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Poppins',
      
      colorScheme: ColorScheme.dark(
        primary: _darkPrimary,
        secondary: Colors.deepPurpleAccent.shade100,
        surface: _darkSurface,
        background: _darkBackground,
        error: Colors.red.shade400,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.grey.shade200,
        onBackground: Colors.grey.shade200,
        onError: Colors.black,
      ),

      scaffoldBackgroundColor: _darkBackground,
      
      appBarTheme: AppBarTheme(
        backgroundColor: _darkSurface,
        elevation: 0,
        iconTheme: const IconThemeData(color: _darkPrimary),
        titleTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _darkPrimary,
        ),
      ),

      cardTheme: CardTheme(
        color: _darkCardBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkPrimary,
          foregroundColor: Colors.black,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkPrimary,
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red.shade400),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),

      iconTheme: IconThemeData(color: Colors.grey.shade400),
    );
  }

  // ─── Helper Methods ────────────────────────────────────────────

  /// Mendapatkan warna card background berdasarkan brightness
  static Color cardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? _lightCardBackground
        : _darkCardBackground;
  }

  /// Mendapatkan warna text primary berdasarkan brightness
  static Color textPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.grey.shade800
        : Colors.grey.shade200;
  }

  /// Mendapatkan warna text secondary berdasarkan brightness
  static Color textSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.grey.shade600
        : Colors.grey.shade400;
  }

  /// Mendapatkan warna border berdasarkan brightness
  static Color borderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Colors.grey.shade200
        : Colors.grey.shade700;
  }

  /// Mendapatkan warna surface (untuk card, dialog, dll)
  static Color surfaceColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? _lightSurface
        : _darkSurface;
  }
}
