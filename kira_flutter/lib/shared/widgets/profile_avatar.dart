/// Profile Avatar Widget with Menu
/// 
/// Top-right profile avatar with glassmorphism effect and popup menu.
library;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/spacing.dart';
import '../../providers/auth_providers.dart';

/// Profile avatar button in top-right corner with menu
class ProfileAvatar extends ConsumerWidget {
  const ProfileAvatar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    
    return userAsync.when(
      data: (user) {
        if (user == null) return const SizedBox.shrink();
        
        return Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          right: 16,
          child: PopupMenuButton(
            offset: const Offset(0, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: Colors.transparent,
            elevation: 0,
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.15),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // User info
                            Text(
                              user.displayName ?? 'User',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: KiraColors.text900,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.email ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: KiraColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            const Divider(height: 1, color: Colors.white24),
                            const SizedBox(height: 8),
                            
                            // Menu items
                            _buildMenuItem(
                              context,
                              ref,
                              icon: Icons.person_outline,
                              label: 'View Profile',
                              onTap: () {
                                Navigator.pop(context);
                                context.go('/reports');
                              },
                            ),
                            const SizedBox(height: 8),
                            _buildMenuItem(
                              context,
                              ref,
                              icon: Icons.swap_horiz,
                              label: 'Switch Account',
                              onTap: () async {
                                Navigator.pop(context);
                                // Sign out from current account
                                final authService = ref.read(authServiceProvider);
                                await authService.signOut();
                                // Immediately trigger Google sign-in again
                                try {
                                  await authService.signInWithGoogle();
                                } catch (e) {
                                  print('Switch account cancelled or failed: $e');
                                }
                              },
                            ),
                            const SizedBox(height: 8),
                            const Divider(height: 1, color: Colors.white24),
                            const SizedBox(height: 8),
                            _buildMenuItem(
                              context,
                              ref,
                              icon: Icons.logout,
                              label: 'Logout',
                              isDestructive: true,
                              onTap: () async {
                                Navigator.pop(context);
                                final authService = ref.read(authServiceProvider);
                                await authService.signOut();
                                if (context.mounted) {
                                  context.go('/login');
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            child: ClipRRect(
              borderRadius: BorderRadius.circular(KiraSpacing.avatarSize / 2),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(
                  width: KiraSpacing.avatarSize,
                  height: KiraSpacing.avatarSize,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.08),
                        Colors.white.withOpacity(0.03),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  child: user.photoURL != null
                      ? ClipOval(
                          child: Image.network(
                            user.photoURL!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildIcon(),
                          ),
                        )
                      : _buildIcon(),
                ),
              ),
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
  
  Widget _buildIcon() {
    return Icon(
      Icons.person_outline,
      size: 18,
      color: KiraColors.textTertiary,
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.05),
              Colors.white.withOpacity(0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isDestructive ? Colors.red.shade400 : KiraColors.textSecondary,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: isDestructive ? Colors.red.shade400 : KiraColors.text900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
