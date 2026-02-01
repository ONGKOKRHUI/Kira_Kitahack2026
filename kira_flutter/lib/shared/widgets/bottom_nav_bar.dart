/// Bottom Navigation Bar
/// 
/// Custom tab bar with glassmorphism and extra rounded corners.
library;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/spacing.dart';

class _TabItem {
  final String path;
  final IconData icon;
  final String label;
  const _TabItem({required this.path, required this.icon, required this.label});
}

class KiraBottomNav extends StatelessWidget {
  const KiraBottomNav({super.key});
  
  static const List<_TabItem> _tabs = [
    _TabItem(path: '/reports', icon: Icons.description_outlined, label: 'Reports'),
    _TabItem(path: '/scan', icon: Icons.camera_alt_outlined, label: 'Scan'),
    _TabItem(path: '/dashboard', icon: Icons.eco_outlined, label: 'Home'),
    _TabItem(path: '/assets', icon: Icons.account_balance_wallet_outlined, label: 'GITA'),
    _TabItem(path: '/emissions', icon: Icons.bar_chart_outlined, label: 'CO₂'),
  ];

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    
    return Container(
      padding: EdgeInsets.only(
        left: KiraSpacing.screenHorizontal,
        right: KiraSpacing.screenHorizontal,
        bottom: 12 + MediaQuery.of(context).padding.bottom,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(KiraSpacing.radiusXl), // 32px - extra round
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
          child: Container(
            height: KiraSpacing.tabBarHeight,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(KiraSpacing.radiusXl),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _tabs.map((tab) {
                final isActive = currentPath == tab.path;
                return Expanded(
                  child: _TabItemWidget(
                    icon: tab.icon,
                    label: tab.label,
                    isActive: isActive,
                    onTap: () => context.go(tab.path),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItemWidget extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItemWidget({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_TabItemWidget> createState() => _TabItemWidgetState();
}

class _TabItemWidgetState extends State<_TabItemWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 80));
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
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
      behavior: HitTestBehavior.opaque,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(scale: _scaleAnimation.value, child: child),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              size: 20,
              color: widget.isActive ? KiraColors.primary500 : KiraColors.textTertiary,
            ),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
                color: widget.isActive ? KiraColors.primary500 : KiraColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
