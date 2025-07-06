// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Mystical color palette
  static const Color primaryPurple = Color(0xFF6B46C1);
  static const Color secondaryBlue = Color(0xFF3B82F6);
  static const Color accentIndigo = Color(0xFF4F46E5);
  static const Color lightPurple = Color(0xFFE0E7FF);
  static const Color darkPurple = Color(0xFF4C1D95);
  static const Color mysticalWhite = Color(0xFFFAFAFA);
  static const Color softGray = Color(0xFFF3F4F6);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textLight = Color(0xFF6B7280);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color successGreen = Color(0xFF10B981);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryPurple, secondaryBlue],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightPurple, mysticalWhite],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [mysticalWhite, lightPurple],
  );

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        brightness: Brightness.light,
        primary: primaryPurple,
        secondary: secondaryBlue,
        surface: mysticalWhite,
        background: mysticalWhite,
        error: errorRed,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        displaySmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        headlineLarge: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: textDark,
        ),
        headlineSmall: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textDark,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textDark,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textDark,
        ),
        titleSmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textDark,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textDark,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textDark,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textLight,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textDark,
        ),
        labelMedium: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textLight,
        ),
        labelSmall: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textLight,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: primaryPurple.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryPurple,
          side: const BorderSide(color: primaryPurple, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryPurple,
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: softGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorRed, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: GoogleFonts.poppins(
          color: textLight,
          fontSize: 14,
        ),
        hintStyle: GoogleFonts.poppins(
          color: textLight,
          fontSize: 14,
        ),
        errorStyle: GoogleFonts.poppins(
          color: errorRed,
          fontSize: 12,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 8,
        shadowColor: primaryPurple.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: mysticalWhite,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        iconTheme: const IconThemeData(
          color: textDark,
          size: 24,
        ),
      ),
      scaffoldBackgroundColor: mysticalWhite,
      dividerColor: lightPurple,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryPurple,
        linearTrackColor: lightPurple,
        circularTrackColor: lightPurple,
      ),
    );
  }

  // Custom decorations
  static BoxDecoration get cardDecoration => BoxDecoration(
        gradient: cardGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryPurple.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      );

  static BoxDecoration get backgroundDecoration => const BoxDecoration(
        gradient: backgroundGradient,
      );

  static BoxDecoration get primaryGradientDecoration => BoxDecoration(
        gradient: primaryGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryPurple.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // Responsive breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Spacing
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;
  static const double spacing64 = 64.0;

  // Border radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
}