import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/services/auth_service.dart';
import '../data/services/user_profile_service.dart';
import '../data/models/user_profile.dart';

// ═══════════════════════════════════════════════════════
// SERVICES
// ═══════════════════════════════════════════════════════

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final userProfileServiceProvider = Provider<UserProfileService>((ref) {
  return UserProfileService();
});

// ═══════════════════════════════════════════════════════
// AUTHENTICATION STATE
// ═══════════════════════════════════════════════════════

/// Current Firebase user (null if not signed in)
final currentUserProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(authServiceProvider);
  return auth.authStateChanges();
});

/// Current user ID (null if not signed in)
final userIdProvider = Provider<String?>((ref) {
  final userAsync = ref.watch(currentUserProvider);
  return userAsync.when(
    data: (user) => user?.uid,
    loading: () => null,
    error: (_, __) => null,
  );
});

// ═══════════════════════════════════════════════════════
// USER PROFILE
// ═══════════════════════════════════════════════════════

/// User profile (null if not set up yet)
final userProfileProvider = FutureProvider<UserProfile?>((ref) async {
  final userAsync = ref.watch(currentUserProvider);
  
  return userAsync.when(
    data: (user) async {
      if (user == null) return null;
      
      final service = ref.read(userProfileServiceProvider);
      return service.getProfile(user.uid);
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

/// User profile stream (real-time updates)
final userProfileStreamProvider = StreamProvider<UserProfile?>((ref) {
  final userId = ref.watch(userIdProvider);
  
  if (userId == null) {
    return Stream.value(null);
  }
  
  final service = ref.watch(userProfileServiceProvider);
  return service.streamProfile(userId);
});

// ═══════════════════════════════════════════════════════
// AUTHENTICATION HELPERS
// ═══════════════════════════════════════════════════════

/// Is user signed in?
final isSignedInProvider = Provider<bool>((ref) {
  final userId = ref.watch(userIdProvider);
  return userId != null;
});

/// Has user completed profile setup?
final hasProfileProvider = Provider<AsyncValue<bool>>((ref) {
  final profileAsync = ref.watch(userProfileStreamProvider);
  return profileAsync.when(
    data: (profile) => AsyncValue.data(profile != null),
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
  );
});
