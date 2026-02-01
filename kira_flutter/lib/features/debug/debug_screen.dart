/// Debug Screen
/// 
/// Development utilities for testing and debugging.
/// Only accessible in debug mode.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/typography.dart';
import '../../shared/widgets/kira_card.dart';
import '../../shared/widgets/kira_button.dart';
import '../../providers/auth_providers.dart';
import '../../data/services/mock_data_service.dart';

class DebugScreen extends ConsumerWidget {
  const DebugScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            
            Text('Debug Tools', style: KiraTypography.h2),
            const SizedBox(height: 8),
            Text(
              'Development utilities',
              style: KiraTypography.bodySmall.copyWith(
                color: KiraColors.textSecondary,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // User Info
            userAsync.when(
              data: (user) {
                if (user == null) return const SizedBox.shrink();
                
                return KiraCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Current User', style: KiraTypography.h4),
                        const SizedBox(height: 8),
                        Text('Email: ${user.email}', style: KiraTypography.bodySmall),
                        Text('UID: ${user.uid}', style: KiraTypography.labelSmall),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            
            const SizedBox(height: 16),
            
            // Mock Data Actions
            KiraCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mock Data', style: KiraTypography.h4),
                    const SizedBox(height: 12),
                    
                    userAsync.when(
                      data: (user) {
                        if (user == null) {
                          return Text(
                            'Sign in to upload mock data',
                            style: KiraTypography.bodySmall.copyWith(
                              color: KiraColors.textSecondary,
                            ),
                          );
                        }
                        
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            KiraButton(
                              label: 'Upload 12 Mock Receipts',
                              onPressed: () async {
                                try {
                                  final mockService = MockDataService();
                                  await mockService.uploadMockData(user.uid);
                                  
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('✅ Mock data uploaded!'),
                                        backgroundColor: KiraColors.success,
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('❌ Error: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                            const SizedBox(height: 12),
                            
                            KiraButton(
                              label: 'Clear All Receipts',
                              onPressed: () async {
                                try {
                                  final mockService = MockDataService();
                                  await mockService.clearUserReceipts(user.uid);
                                  
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('🗑️ All receipts cleared'),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('❌ Error: $e'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        );
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const Text('Error loading user'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
