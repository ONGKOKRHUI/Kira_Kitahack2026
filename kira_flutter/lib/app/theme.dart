/// Kira App Theme Configuration
/// 
/// Unified ThemeData for the entire app, based on Material Design 3
/// with custom Kira dark green color scheme.
/// 
/// Usage:
/// ```dart
/// MaterialApp(
///   theme: KiraTheme.darkTheme,
///   ...
/// )
/// ```
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/colors.dart';

/// Theme configuration for Kira app
abstract class KiraTheme {
  /// Main dark theme - used throughout the app
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color scheme based on Kira's green palette
      colorScheme: ColorScheme.dark(
        primary: KiraColors.primary500,
        primaryContainer: KiraColors.primary700,
        secondary: KiraColors.primary400,
        secondaryContainer: KiraColors.primary800,
        surface: KiraColors.bgPrimary,
        onSurface: KiraColors.textPrimary,
        onPrimary: Colors.white,
        error: KiraColors.primary600,
      ),
      
      // Scaffold background
      scaffoldBackgroundColor: Colors.transparent,
      
      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      
      // Card theme - extra rounded
      cardTheme: CardThemeData(
        color: KiraColors.bgCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24), // radiusLg
          side: BorderSide(color: KiraColors.glassBorder),
        ),
      ),
      
      // Text theme using Inter
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 64,
          fontWeight: FontWeight.w700,
          letterSpacing: -3,
          color: KiraColors.textPrimary,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 42,
          fontWeight: FontWeight.w700,
          letterSpacing: -2,
          color: KiraColors.textPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: KiraColors.textPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: KiraColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: KiraColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: KiraColors.textPrimary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: KiraColors.textSecondary,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: KiraColors.textTertiary,
        ),
      ),
      
      // Elevated button theme (Primary buttons)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: KiraColors.primary500,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Outlined button theme (Secondary buttons)
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: KiraColors.textPrimary,
          side: BorderSide(color: KiraColors.glassBorder),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: KiraColors.primary500,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: KiraColors.glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: KiraColors.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: KiraColors.primary500),
        ),
        hintStyle: GoogleFonts.inter(
          color: KiraColors.textTertiary,
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      
      // Divider theme
      dividerTheme: DividerThemeData(
        color: Colors.white.withOpacity(0.06),
        thickness: 1,
      ),
      
      // Icon theme
      iconTheme: const IconThemeData(
        color: KiraColors.textPrimary,
        size: 20,
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
        selectedItemColor: KiraColors.primary500,
        unselectedItemColor: KiraColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: KiraColors.primary500,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
    );
  }
}
