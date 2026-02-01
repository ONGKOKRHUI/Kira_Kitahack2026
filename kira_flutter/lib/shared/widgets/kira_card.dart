/// KiraCard Widget
/// 
/// Glassmorphism card with backdrop blur and smooth tap feedback.
/// Matches React .card component styling with improved curves.
library;

import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/spacing.dart';

/// Glassmorphism card widget with tap animation
class KiraCard extends StatefulWidget {
  /// Card content
  final Widget child;
  
  /// Custom padding (default: 14px all sides)
  final EdgeInsetsGeometry? padding;
  
  /// Custom border radius (default: radiusLg = 20px)
  final double? borderRadius;
  
  /// Whether to show blur effect (default: true)
  final bool useBlur;
  
  /// Custom background color
  final Color? backgroundColor;
  
  /// Optional tap callback (for interactive cards)
  final VoidCallback? onTap;

  const KiraCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.useBlur = true,
    this.backgroundColor,
    this.onTap,
  });

  @override
  State<KiraCard> createState() => _KiraCardState();
}

class _KiraCardState extends State<KiraCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
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
    final radius = widget.borderRadius ?? KiraSpacing.radiusLg;
    final isInteractive = widget.onTap != null;
    
    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: widget.useBlur 
            ? ImageFilter.blur(sigmaX: 20, sigmaY: 20)
            : ImageFilter.blur(sigmaX: 0, sigmaY: 0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: widget.padding ?? const EdgeInsets.all(KiraSpacing.cardPadding),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? 
                (isInteractive && _isPressed 
                    ? KiraColors.bgCardBright 
                    : KiraColors.bgCard),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: isInteractive && _isPressed 
                  ? KiraColors.glassBorderBright 
                  : KiraColors.glassBorder,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
    
    if (isInteractive) {
      return GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(
            scale: _scaleAnimation.value,
            child: card,
          ),
        ),
      );
    }
    
    return card;
  }
}
