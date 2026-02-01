/// Floating AI Button
/// 
/// Floating action button for opening the Kira AI chat.
/// Positioned at bottom-right above the tab bar.
/// 
/// Usage:
/// ```dart
/// Stack(
///   children: [
///     // Screen content
///     const FloatingAiButton(onPressed: _openAiChat),
///   ],
/// )
/// ```
library;

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/spacing.dart';

/// Floating AI chat button with glow effect
class FloatingAiButton extends StatelessWidget {
  /// Callback when button is pressed
  final VoidCallback onPressed;

  const FloatingAiButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 90, // Above tab bar
      right: 20,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: KiraSpacing.fabSize,
          height: KiraSpacing.fabSize,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [KiraColors.primary500, KiraColors.primary400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: KiraColors.primary500.withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: KiraColors.primary500.withOpacity(0.2),
                blurRadius: 24,
              ),
            ],
          ),
          child: const Center(
            child: _AiBotIcon(),
          ),
        ),
      ),
    );
  }
}

/// Custom AI bot icon matching React SVG
class _AiBotIcon extends StatelessWidget {
  const _AiBotIcon();

  @override
  Widget build(BuildContext context) {
    // Using a simple icon for now - can be replaced with custom SVG
    return const Icon(
      Icons.smart_toy_outlined,
      color: Colors.white,
      size: 20,
    );
  }
}
