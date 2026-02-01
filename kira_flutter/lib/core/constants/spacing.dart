/// Kira Design System - Spacing Constants
/// 
/// Consistent spacing values used throughout the app.
/// Based on 4px grid system. Extra rounded corners per user request.
library;

/// Spacing constants following a 4px base grid
abstract class KiraSpacing {
  // ============================================
  // Base Spacing (4px increments)
  // ============================================
  
  /// 4px - Minimal spacing
  static const double xs = 4.0;
  
  /// 8px - Tight spacing
  static const double sm = 8.0;
  
  /// 12px - Small-medium
  static const double md = 12.0;
  
  /// 16px - Standard spacing
  static const double lg = 16.0;
  
  /// 20px - Comfortable spacing
  static const double xl = 20.0;
  
  /// 24px - Section spacing
  static const double xxl = 24.0;
  
  /// 32px - Large section spacing
  static const double xxxl = 32.0;

  // ============================================
  // Semantic Spacing
  // ============================================
  
  static const double cardPadding = 14.0;
  static const double screenHorizontal = 16.0;
  static const double sectionGap = 20.0;
  static const double listItemGap = 10.0;
  static const double screenBottom = 100.0;
  
  /// Hero top spacing - more space for comfortable layout
  static const double heroTop = 56.0;
  
  /// Reduced gap between change indicator and period selector
  static const double heroBottom = 24.0;

  // ============================================
  // Border Radius - EXTRA ROUNDED
  // ============================================
  
  /// Small radius (badges, tiny elements) - 12px
  static const double radiusSm = 12.0;
  
  /// Medium radius (buttons, inputs, list items) - 18px
  static const double radiusMd = 18.0;
  
  /// Large radius (cards) - 24px
  static const double radiusLg = 24.0;
  
  /// Extra large radius (nav bar, sheets) - 32px
  static const double radiusXl = 32.0;
  
  /// Full/pill radius
  static const double radiusFull = 9999.0;

  // ============================================
  // Component Sizes
  // ============================================
  
  static const double tabBarHeight = 70.0;
  static const double headerHeight = 56.0;
  static const double fabSize = 48.0;
  static const double avatarSize = 40.0;
  static const double iconBgSize = 40.0;
}
