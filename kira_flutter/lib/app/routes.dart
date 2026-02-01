/// App Routes Configuration
/// 
/// GoRouter setup with authentication routing and instant page switching.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/scan/presentation/scan_screen.dart';
import '../features/assets/presentation/assets_screen.dart';
import '../features/emissions/presentation/emissions_screen.dart';
import '../features/reports/presentation/reports_screen.dart';
import '../features/debug/debug_screen.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/profile_setup_screen.dart';
import '../shared/layouts/main_scaffold.dart';
import '../providers/auth_providers.dart';

/// Router configuration with authentication
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(currentUserProvider);
  final hasProfile = ref.watch(hasProfileProvider);
  
  return GoRouter(
    initialLocation: '/dashboard',
    debugLogDiagnostics: false,
    
    // Authentication redirect logic
    redirect: (context, state) {
      final isAuthPage = state.uri.path == '/login';
      final isProfilePage = state.uri.path == '/profile-setup';
      
      return authState.when(
        data: (user) {
          // Not logged in - redirect to login
          if (user == null) {
            return isAuthPage ? null : '/login';
          }
          
          // Check profile status
          final profileStatus = hasProfile;
          
          return profileStatus.when(
            data: (hasProf) {
              print('🔍 Route Check: Path=${state.uri.path}, User=${user.uid}, HasProfile=$hasProf, isAuthPage=$isAuthPage, isProfilePage=$isProfilePage');

              // Logged in but no profile - redirect to profile setup
              if (!hasProf && !isProfilePage) {
                print('🚀 MATCH Condition 1: !hasProf && !isProfilePage → /profile-setup');
                return '/profile-setup';
              }
              
              // Logged in WITH profile - redirect away from auth pages to dashboard
              if (hasProf && (isAuthPage || isProfilePage)) {
                print('🚀 MATCH Condition 2: hasProf && (isAuthPage || isProfilePage) → /dashboard');
                return '/dashboard';
              }
              
              print('✅ No redirects needed, staying on ${state.uri.path}');
              return null; // No redirect needed
            },
            loading: () {
               print('⏳ Profile Loading... staying on ${state.uri.path}');
               return null;
            },
            error: (e, s) {
               print('❌ Profile Error: $e');
               return '/profile-setup';
            },
          );
        },
        loading: () => null, // Stay on current page while loading
        error: (_, __) => isAuthPage ? null : '/login',
      );
    },
    
    routes: [
      // ═══════════════════════════════════════════════
      // Auth Routes (no scaffold)
      // ═══════════════════════════════════════════════
      GoRoute(
        path: '/login',
        name: 'login',
        pageBuilder: (context, state) => _buildNoTransitionPage(state, const LoginScreen()),
      ),
      GoRoute(
        path: '/profile-setup',
        name: 'profile-setup',
        pageBuilder: (context, state) => _buildNoTransitionPage(state, const ProfileSetupScreen()),
      ),
      
      // ═══════════════════════════════════════════════
      // Main App Routes (with scaffold)
      // ═══════════════════════════════════════════════
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            pageBuilder: (context, state) => _buildNoTransitionPage(state, const DashboardScreen()),
          ),
          GoRoute(
            path: '/scan',
            name: 'scan',
            pageBuilder: (context, state) => _buildNoTransitionPage(state, const ScanScreen()),
          ),
          GoRoute(
            path: '/assets',
            name: 'assets',
            pageBuilder: (context, state) => _buildNoTransitionPage(state, const AssetsScreen()),
          ),
          GoRoute(
            path: '/emissions',
            name: 'emissions',
            pageBuilder: (context, state) => _buildNoTransitionPage(state, const EmissionsScreen()),
          ),
          GoRoute(
            path: '/reports',
            name: 'reports',
            pageBuilder: (context, state) => _buildNoTransitionPage(state, const ReportsScreen()),
          ),
          GoRoute(
            path: '/debug',
            name: 'debug',
            pageBuilder: (context, state) => _buildNoTransitionPage(state, const DebugScreen()),
          ),
        ],
      ),
    ],
  );
});

/// No transition - instant page switch
NoTransitionPage<void> _buildNoTransitionPage(GoRouterState state, Widget child) {
  return NoTransitionPage<void>(
    key: state.pageKey,
    child: child,
  );
}
