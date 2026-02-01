/// KiraBadge - Status Badge Widget
/// 
/// Badge component for showing status (success, warning, etc.)
/// matching the React implementation's .badge class.
/// 
/// Usage:
/// ```dart
/// KiraBadge.success(
///   label: 'GITA',
///   icon: Icons.check_circle,
/// )
/// ```
library;

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

/// Badge style types
enum KiraBadgeStyle {
  success,
  warning,
  info,
}

/// Status badge component
class KiraBadge extends StatelessWidget {
  /// Badge label text
  final String label;
  
  /// Optional leading icon
  final IconData? icon;
  
  /// Badge style
  final KiraBadgeStyle style;

  const KiraBadge({
    super.key,
    required this.label,
    this.icon,
    this.style = KiraBadgeStyle.success,
  });
  
  /// Success badge (green)
  factory KiraBadge.success({
    Key? key,
    required String label,
    IconData? icon,
  }) {
    return KiraBadge(
      key: key,
      label: label,
      icon: icon,
      style: KiraBadgeStyle.success,
    );
  }
  
  /// Warning badge (yellow-green)
  factory KiraBadge.warning({
    Key? key,
    required String label,
    IconData? icon,
  }) {
    return KiraBadge(
      key: key,
      label: label,
      icon: icon,
      style: KiraBadgeStyle.warning,
    );
  }
  
  /// Info badge (light green)
  factory KiraBadge.info({
    Key? key,
    required String label,
    IconData? icon,
  }) {
    return KiraBadge(
      key: key,
      label: label,
      icon: icon,
      style: KiraBadgeStyle.info,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 10, color: colors.foreground),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: colors.foreground,
            ),
          ),
        ],
      ),
    );
  }
  
  ({Color background, Color foreground}) _getColors() {
    switch (style) {
      case KiraBadgeStyle.success:
        return (
          background: KiraColors.primary500.withOpacity(0.15),
          foreground: KiraColors.primary400,
        );
      case KiraBadgeStyle.warning:
        return (
          background: KiraColors.primary400.withOpacity(0.12),
          foreground: KiraColors.primary300,
        );
      case KiraBadgeStyle.info:
        return (
          background: Colors.white.withOpacity(0.1),
          foreground: Colors.white.withOpacity(0.8),
        );
    }
  }
}
