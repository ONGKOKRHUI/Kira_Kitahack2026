/// Kira Design System - Typography
/// 
/// Text styles matching the React implementation's typography.
/// Uses Inter font family with consistent sizing.
/// 
/// Usage:
/// ```dart
/// Text('Hello', style: KiraTypography.heroLarge)
/// Text('Label', style: KiraTypography.caption)
/// ```
library;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// Typography styles for consistent text across the app
abstract class KiraTypography {
  // ============================================
  // Font Family
  // ============================================
  
  /// Base text style with Inter font
  static TextStyle get _baseStyle => GoogleFonts.inter(
    color: KiraColors.textPrimary,
  );

  // ============================================
  // Display / Hero Styles
  // ============================================
  
  /// Large hero number (64px) - Main dashboard stats
  static TextStyle get heroLarge => _baseStyle.copyWith(
    fontSize: 64,
    fontWeight: FontWeight.w700,
    letterSpacing: -3,
    height: 1,
  );
  
  /// Medium hero number (42px) - Report preview
  static TextStyle get heroMedium => _baseStyle.copyWith(
    fontSize: 42,
    fontWeight: FontWeight.w700,
    letterSpacing: -2,
    height: 1,
  );
  
  /// Standard hero number (48px) - Sub-page hero stats
  static TextStyle get hero => _baseStyle.copyWith(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    letterSpacing: -2,
    height: 1,
  );

  // ============================================
  // Headings
  // ============================================
  
  /// Page title (28px)
  static TextStyle get h1 => _baseStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w700,
  );
  
  /// Page heading (26px)
  static TextStyle get h2 => _baseStyle.copyWith(
    fontSize: 26,
    fontWeight: FontWeight.w700,
  );
  
  /// Section title (18px)
  static TextStyle get h3 => _baseStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );
  
  /// Sub-section title (12px) - used for hero labels
  static TextStyle get h4 => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  // ============================================
  // Body Text
  // ============================================
  
  /// Large body text (16px)
  static TextStyle get bodyLarge => _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
  
  /// Standard body text (14px)
  static TextStyle get bodyMedium => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  
  /// Small body text (13px)
  static TextStyle get bodySmall => _baseStyle.copyWith(
    fontSize: 13,
    fontWeight: FontWeight.w400,
  );

  // ============================================
  // Labels & Captions
  // ============================================
  
  /// Section title label (12px uppercase)
  static TextStyle get sectionTitle => _baseStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: KiraColors.textSecondary,
    letterSpacing: 0.5,
  );
  
  /// Small label (11px)
  static TextStyle get labelSmall => _baseStyle.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: KiraColors.textTertiary,
  );
  
  /// Caption text (10px uppercase)
  static TextStyle get caption => _baseStyle.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: KiraColors.textTertiary,
    letterSpacing: 1,
  );
  
  /// Very small text (9px)
  static TextStyle get micro => _baseStyle.copyWith(
    fontSize: 9,
    fontWeight: FontWeight.w600,
    color: KiraColors.textTertiary,
  );

  // ============================================
  // Special Styles
  // ============================================
  
  /// Stat value (18px bold)
  static TextStyle get statValue => _baseStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w700,
  );
  
  /// Stat label (10px)
  static TextStyle get statLabel => _baseStyle.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: KiraColors.textTertiary,
  );
  
  /// Button text (14px semibold)
  static TextStyle get button => _baseStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
  
  /// Tab bar label (11px)
  static TextStyle get tabLabel => _baseStyle.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );
  
  /// Badge text (10px)
  static TextStyle get badge => _baseStyle.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );

  // ============================================
  // Aliases for Auth Screens
  // ============================================
  
  /// body1 alias (same as bodyLarge)
  static TextStyle get body1 => bodyLarge;
  
  /// body2 alias (same as bodySmall)
  static TextStyle get body2 => bodySmall;
}
