/// Main Scaffold Layout
/// 
/// Wrapper layout with gradient background, bottom nav, and AI chat.
library;

import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/floating_ai_button.dart';
import '../widgets/profile_avatar.dart';
import '../../features/chat/presentation/kira_ai_chat.dart';

/// Main scaffold wrapper for all screens
class MainScaffold extends StatefulWidget {
  final Widget child;
  final bool showBottomNav;
  final bool showAiButton;
  final bool showProfileAvatar;

  const MainScaffold({
    super.key,
    required this.child,
    this.showBottomNav = true,
    this.showAiButton = true,
    this.showProfileAvatar = true,
  });

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  bool _isAiChatOpen = false;

  void _openAiChat() {
    setState(() => _isAiChatOpen = true);
  }

  void _closeAiChat() {
    setState(() => _isAiChatOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              KiraColors.gradientTop,
              KiraColors.gradientMid,
              KiraColors.gradientBottom,
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Main content
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: widget.child,
                ),
              ),
              
              // Profile avatar
              if (widget.showProfileAvatar)
                const ProfileAvatar(),
              
              // Floating AI button
              if (widget.showAiButton)
                FloatingAiButton(onPressed: _openAiChat),
              
              // AI Chat overlay
              if (_isAiChatOpen)
                KiraAIChat(onClose: _closeAiChat),
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.showBottomNav 
          ? const KiraBottomNav() 
          : null,
      extendBody: true,
    );
  }
}
