/// Kira Design System - Color Palette
/// 
/// Exact color values from the React implementation's index.css
/// These colors create the dark green forest theme with glassmorphism effects.
/// 
/// Usage:
/// ```dart
/// Container(color: KiraColors.primary500)
/// Text(style: TextStyle(color: KiraColors.textPrimary))
/// ```
library;

import 'package:flutter/material.dart';

/// Primary color palette - Emerald green scale
/// 
/// Primary-500 (#10B981) is the main accent color used for:
/// - Active tab icons
/// - Success badges
/// - Chart highlights
/// - CTAs
abstract class KiraColors {
  // ============================================
  // Primary Scale - Emerald Green
  // ============================================
  
  /// Lightest green - used for subtle backgrounds
  static const Color primary50 = Color(0xFFECFDF5);
  
  /// Very light green
  static const Color primary100 = Color(0xFFD1FAE5);
  
  /// Light green
  static const Color primary200 = Color(0xFFA7F3D0);
  
  /// Scope 3 color - Supply chain emissions
  static const Color primary300 = Color(0xFF6EE7B7);
  
  /// Scope 2 color - Electricity emissions
  static const Color primary400 = Color(0xFF34D399);
  
  /// **Main accent color** - CTAs, active states, success
  static const Color primary500 = Color(0xFF10B981);
  
  /// Scope 1 color - Direct emissions
  static const Color primary600 = Color(0xFF059669);
  
  /// Darker green
  static const Color primary700 = Color(0xFF047857);
  
  /// Dark green
  static const Color primary800 = Color(0xFF065F46);
  
  /// Darkest green
  static const Color primary900 = Color(0xFF064E3B);

  // ============================================
  // Background Gradient
  // Used for app-bg gradient from top to bottom
  // ============================================
  
  /// Top of gradient - lighter forest green
  static const Color gradientTop = Color(0xFF1A5C45);
  
  /// Middle of gradient
  static const Color gradientMid = Color(0xFF0A3D2E);
  
  /// Bottom of gradient - darkest
  static const Color gradientBottom = Color(0xFF051A14);

  // ============================================
  // Surface Colors
  // ============================================
  
  /// Primary background (solid)
  static const Color bgPrimary = Color(0xFF051A14);
  
  /// Card background (6% white with blur)
  static Color get bgCard => Colors.white.withOpacity(0.06);
  
  /// Brighter card background (10% white)
  static Color get bgCardBright => Colors.white.withOpacity(0.10);
  
  /// Solid card background (for non-blur contexts)
  static const Color bgCardSolid = Color(0xFF0D2920);

  // ============================================
  // Glass / Border Colors
  // ============================================
  
  /// Standard glassmorphism border
  static Color get glassBorder => Colors.white.withOpacity(0.12);
  
  /// Brighter glass border (for active states)
  static Color get glassBorderBright => Colors.white.withOpacity(0.20);

  // ============================================
  // Text Colors
  // ============================================
  
  /// Primary text - pure white
  static const Color textPrimary = Colors.white;
  
  /// Secondary text - 75% white
  static Color get textSecondary => Colors.white.withOpacity(0.75);
  
  /// Tertiary text - 45% white (labels, hints)
  static Color get textTertiary => Colors.white.withOpacity(0.45);
  
  /// Accent text - matches primary300
  static const Color textAccent = Color(0xFF6EE7B7);

  // ============================================
  // Status Colors
  // All derived from green palette for consistency
  // ============================================
  
  /// Success color
  static const Color success = Color(0xFF10B981);
  
  /// Success background (15% opacity)
  static Color get successBg => const Color(0xFF10B981).withOpacity(0.15);
  
  /// Warning color
  static const Color warning = Color(0xFF34D399);
  
  /// Warning background
  static Color get warningBg => const Color(0xFF34D399).withOpacity(0.12);

  // ============================================
  // Scope Colors (for emissions)
  // ============================================
  
  /// Scope 1 - Direct emissions (fuel, fleet)
  static const Color scope1 = Color(0xFF10B981);
  
  /// Scope 2 - Indirect emissions (electricity)
  static const Color scope2 = Color(0xFF34D399);
  
  /// Scope 3 - Value chain (suppliers, logistics)
  static const Color scope3 = Color(0xFF6EE7B7);

  // ============================================
  // Aliases for Auth Screens
  // ============================================
  
  /// Background color alias
  static const Color background = bgPrimary;
  
  /// Surface color alias
  static Color get surface => bgCardSolid;
  
  /// Border color alias
  static Color get border => glassBorder;
  
  /// Text color aliases
  static const Color text900 = textPrimary;
  static Color get text700 => textSecondary;
  static Color get text600 => textSecondary;
  static Color get text500 => textTertiary;
  static Color get text400 => textTertiary;

  // ============================================
  // Chart Colors
  // ============================================
  
  /// Pie chart / Line chart colors
  static const List<Color> chartColors = [
    scope1,
    scope2,
    scope3,
  ];
}
