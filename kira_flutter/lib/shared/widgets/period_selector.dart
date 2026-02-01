/// Period Selector Widget
/// 
/// Horizontal row of period buttons with smooth tap animations.
library;

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/spacing.dart';

/// Period selector with animated buttons
class PeriodSelector extends StatelessWidget {
  /// List of period options
  final List<String> periods;
  
  /// Currently selected period
  final String selected;
  
  /// Callback when period changes
  final ValueChanged<String> onChanged;
  
  /// Whether to center the buttons (default: true)
  final bool centered;

  const PeriodSelector({
    super.key,
    this.periods = const ['Today', 'Week', 'Month', 'Year'],
    required this.selected,
    required this.onChanged,
    this.centered = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: centered 
          ? MainAxisAlignment.center 
          : MainAxisAlignment.start,
      children: [
        for (int i = 0; i < periods.length; i++) ...[
          _PeriodButton(
            label: periods[i],
            isActive: periods[i] == selected,
            onTap: () => onChanged(periods[i]),
          ),
          if (i < periods.length - 1) const SizedBox(width: 6),
        ],
      ],
    );
  }
}

/// Individual period button with tap animation
class _PeriodButton extends StatefulWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _PeriodButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_PeriodButton> createState() => _PeriodButtonState();
}

class _PeriodButtonState extends State<_PeriodButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 7,
          ),
          decoration: BoxDecoration(
            color: widget.isActive 
                ? Colors.white.withValues(alpha: 0.12) 
                : Colors.transparent,
            borderRadius: BorderRadius.circular(KiraSpacing.radiusSm),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 12,
              fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
              color: widget.isActive ? Colors.white : KiraColors.textTertiary,
            ),
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}
