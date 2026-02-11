/// Receipt Providers - Firebase Firestore Integration
///
/// Provides real-time receipt data from Firestore.

import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kira_app/data/repositories/carbon_item_repository.dart';
import 'package:kira_app/data/repositories/gita_item_repository.dart';
import 'package:kira_app/data/repositories/item_repository.dart';
import 'package:kira_app/data/repositories/receipt_repository.dart';
import 'package:kira_app/data/services/receipt_service.dart';
import '../data/models/receipt.dart';
import '../data/services/genkit_service.dart';
import 'auth_providers.dart';

// ═══════════════════════════════════════════════════════
// SERVICES
// ═══════════════════════════════════════════════════════

final genkitServiceProvider = Provider<GenkitService>((ref) {
  return GenkitService();
});

final receiptRepositoryProvider  = Provider<ReceiptRepository>((ref) {
  return ReceiptRepository();
});

final gitaItemRepositoryProvider = Provider<GitaItemRepository>((ref) {
  return GitaItemRepository();
});

final carbonItemRepositoryProvider = Provider<CarbonItemRepository>((ref) {
  return CarbonItemRepository();
});


final receiptServiceProvider = Provider<ReceiptService>((ref) {
  return ReceiptService(
    receiptRepository: ref.read(receiptRepositoryProvider),
    gitaItemRepository: ref.read(gitaItemRepositoryProvider),
    carbonItemRepository: ref.read(carbonItemRepositoryProvider),
    genkitService: ref.read(genkitServiceProvider)
  );
});

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// ═══════════════════════════════════════════════════════
// RECEIPT STREAM (Real-time from Firestore)
// ═══════════════════════════════════════════════════════

/// Real-time stream of all receipts for current user
final receiptsStreamProvider = StreamProvider<List<Receipt>>((ref) {
  final userId = ref.watch(userIdProvider);
  
  if (userId == null) {
    return Stream.value([]);
  }
  
  final firestore = ref.watch(firestoreProvider);
  
  return firestore
      .collection('users/$userId/receipts')
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map((doc) => Receipt.fromFirestore(doc.data()))
            .toList();
      });
});

// ═══════════════════════════════════════════════════════
// COMPUTED VALUES (Auto-update when receipts change)
// ═══════════════════════════════════════════════════════

/// Total CO2 emissions (tonnes)
final totalCO2Provider = Provider<double>((ref) {
  final receiptsAsync = ref.watch(receiptsStreamProvider);
  
  return receiptsAsync.when(
    data: (receipts) {
      final totalKg = receipts.fold(0.0, (sum, r) => sum + r.co2Kg);
      return totalKg / 1000; // Convert to tonnes
    },
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});

/// CO2 by scope (tonnes)
final co2ByScopeProvider = Provider.family<double, int>((ref, scope) {
  final receiptsAsync = ref.watch(receiptsStreamProvider);
  
  return receiptsAsync.when(
    data: (receipts) {
      final scopeReceipts = receipts.where((r) => r.scope == scope);
      final totalKg = scopeReceipts.fold(0.0, (sum, r) => sum + r.co2Kg);
      return totalKg / 1000; // Convert to tonnes
    },
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});

/// Receipts by scope
final receiptsByScopeProvider = Provider.family<List<Receipt>, int>((ref, scope) {
  final receiptsAsync = ref.watch(receiptsStreamProvider);
  
  return receiptsAsync.when(
    data: (receipts) => receipts.where((r) => r.scope == scope).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

/// GITA eligible receipts
final gitaReceiptsProvider = Provider<List<Receipt>>((ref) {
  final receiptsAsync = ref.watch(receiptsStreamProvider);
  
  return receiptsAsync.when(
    data: (receipts) => receipts.where((r) => r.gitaEligible).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

/// Total GITA tax savings (RM)
final totalGitaSavingsProvider = Provider<double>((ref) {
  final gitaReceipts = ref.watch(gitaReceiptsProvider);
  
  return gitaReceipts.fold(0.0, (sum, r) => sum + (r.gitaAllowance ?? 0));
});

/// GITA receipts by tier
final gitaReceiptsByTierProvider = Provider.family<List<Receipt>, int>((ref, tier) {
  final gitaReceipts = ref.watch(gitaReceiptsProvider);
  
  return gitaReceipts.where((r) => r.gitaTier == tier).toList();
});

// ═══════════════════════════════════════════════════════
// RECEIPT UPLOAD
// ═══════════════════════════════════════════════════════

/// Receipt upload state notifier
// class ReceiptUploadNotifier extends StateNotifier<AsyncValue<void>> {
class ReceiptUploadNotifier extends AsyncNotifier<void> {
  final GenkitService _genkit;
  final String? _userId;
  
  ReceiptUploadNotifier(this._genkit, this._userId) : super(const AsyncValue.data(null));

  @override
  Future<void> build() async {
    // abstract implementation
  }
  
  /// Upload receipt from bytes
  Future<void> uploadReceipt(Uint8List imageBytes) async {
    if (_userId == null) {
      state = AsyncValue.error('Not authenticated', StackTrace.current);
      return;
    }
    
    state = const AsyncValue.loading();
    
    try {
      print('📤 Uploading receipt...');
      
      // Genkit processes and saves to Firestore automatically
      // final receipt = await _genkit.processReceipt(imageBytes, _userId!);
      final receiptService = ref.read(receiptServiceProvider);
      final receipt = await receiptService.processReceipt(imageBytes, _userId!);
      
      print('✅ Receipt uploaded: ${receipt.id}');
      state = const AsyncValue.data(null);
    } catch (e, st) {
      print('❌ Upload failed: $e');
      state = AsyncValue.error(e, st);
    }
  }
  
  /// Alias for uploadReceipt (backwards compatibility)
  Future<void> uploadReceiptBytes(Uint8List imageBytes, String path) async {
    await uploadReceipt(imageBytes);
  }
  
  /// Reset state
  void reset() {
    state = const AsyncValue.data(null);
  }
}

final receiptUploadProvider = StateNotifierProvider<ReceiptUploadNotifier, AsyncValue<void>>((ref) {
  final genkit = ref.watch(genkitServiceProvider);
  final userId = ref.watch(userIdProvider);
  
  return ReceiptUploadNotifier(genkit, userId);
});
