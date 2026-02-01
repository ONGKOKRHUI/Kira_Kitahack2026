/// KiraButton Widget
/// 
/// Custom button component with primary/secondary styles.
/// Features gradient backgrounds, smooth press animations, and loading states.
library;

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/spacing.dart';

/// Button style variants
enum KiraButtonStyle {
  primary,
  secondary,
}

/// Custom button widget with Kira styling and smooth press feedback
class KiraButton extends StatefulWidget {
  /// Button label text
  final String label;
  
  /// Leading icon (optional)
  final IconData? icon;
  
  /// Trailing icon (optional)
  final IconData? trailingIcon;
  
  /// Button style variant
  final KiraButtonStyle style;
  
  /// Whether button is in loading state
  final bool isLoading;
  
  /// Whether button is disabled
  final bool isDisabled;
  
  /// Whether button should expand to full width
  final bool expanded;
  
  /// Callback when button is pressed
  final VoidCallback? onPressed;

  const KiraButton({
    super.key,
    required this.label,
    this.icon,
    this.trailingIcon,
    this.style = KiraButtonStyle.primary,
    this.isLoading = false,
    this.isDisabled = false,
    this.expanded = false,
    this.onPressed,
  });
  
  /// Primary style button (green gradient)
  factory KiraButton.primary({
    Key? key,
    required String label,
    IconData? icon,
    IconData? trailingIcon,
    bool isLoading = false,
    bool isDisabled = false,
    bool expanded = false,
    VoidCallback? onPressed,
  }) {
    return KiraButton(
      key: key,
      label: label,
      icon: icon,
      trailingIcon: trailingIcon,
      style: KiraButtonStyle.primary,
      isLoading: isLoading,
      isDisabled: isDisabled,
      expanded: expanded,
      onPressed: onPressed,
    );
  }
  
  /// Secondary style button (glass/outline)
  factory KiraButton.secondary({
    Key? key,
    required String label,
    IconData? icon,
    IconData? trailingIcon,
    bool isLoading = false,
    bool isDisabled = false,
    bool expanded = false,
    VoidCallback? onPressed,
  }) {
    return KiraButton(
      key: key,
      label: label,
      icon: icon,
      trailingIcon: trailingIcon,
      style: KiraButtonStyle.secondary,
      isLoading: isLoading,
      isDisabled: isDisabled,
      expanded: expanded,
      onPressed: onPressed,
    );
  }

  @override
  State<KiraButton> createState() => _KiraButtonState();
}

class _KiraButtonState extends State<KiraButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.isDisabled && !widget.isLoading) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final isPrimary = widget.style == KiraButtonStyle.primary;
    final isEnabled = !widget.isDisabled && !widget.isLoading;
    
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: isEnabled ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: isEnabled ? (_isPressed ? 0.9 : 1.0) : 0.5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isPrimary 
                      ? const LinearGradient(
                          colors: [KiraColors.primary500, KiraColors.primary600],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        )
                      : null,
                  color: isPrimary ? null : Colors.white.withValues(alpha: _isPressed ? 0.12 : 0.08),
                  borderRadius: BorderRadius.circular(KiraSpacing.radiusMd),
                  border: isPrimary 
                      ? null 
                      : Border.all(
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                  boxShadow: isPrimary ? [
                    BoxShadow(
                      color: KiraColors.primary500.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ] : null,
                ),
                child: _buildContent(isPrimary),
              ),
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildContent(bool isPrimary) {
    if (widget.isLoading) {
      return SizedBox(
        width: widget.expanded ? double.infinity : null,
        child: const Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ),
      );
    }
    
    return Row(
      mainAxisSize: widget.expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(
            widget.icon,
            size: 16,
            color: isPrimary ? Colors.white : KiraColors.textPrimary,
          ),
          const SizedBox(width: 8),
        ],
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isPrimary ? Colors.white : KiraColors.textPrimary,
          ),
        ),
        if (widget.trailingIcon != null) ...[
          const SizedBox(width: 8),
          Icon(
            widget.trailingIcon,
            size: 16,
            color: isPrimary ? Colors.white : KiraColors.textPrimary,
          ),
        ],
      ],
    );
  }
}
