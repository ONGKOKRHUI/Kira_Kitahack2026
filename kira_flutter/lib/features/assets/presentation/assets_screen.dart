/// Assets Screen (GITA)
/// 
/// GITA tax savings display with verified green assets list.
/// Matches React Assets.jsx.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/spacing.dart';
import '../../../core/constants/typography.dart';
import '../../../shared/widgets/kira_card.dart';
import '../../../shared/widgets/kira_badge.dart';
import '../../../shared/widgets/period_selector.dart';
import '../../../providers/receipt_providers.dart';

/// Assets screen implementation
class AssetsScreen extends ConsumerStatefulWidget {
  const AssetsScreen({super.key});

  @override
  ConsumerState<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends ConsumerState<AssetsScreen> {
  String _period = 'Year';

  @override
  Widget build(BuildContext context) {
    final receiptsAsync = ref.watch(receiptsStreamProvider);
    
    return receiptsAsync.when(
      data: (allReceipts) {
        // Filter for GITA-eligible receipts
        final gitaReceipts = allReceipts.where((r) => r.gitaEligible).toList();
        final totalSavings = gitaReceipts.fold(0.0, (sum, r) => sum + r.gitaAllowance);
        
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section
              _buildHeroSection(totalSavings.toInt(), 0),
              
              const SizedBox(height: 24),
              
              // GITA Assets List or Empty State
              if (gitaReceipts.isEmpty)
                _buildEmptyState()
              else
                _buildGitaAssetsList(gitaReceipts),
              
              const SizedBox(height: 20),
              
              // Info Card
              _buildInfoCard(),
              
              const SizedBox(height: KiraSpacing.screenBottom),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          Icon(
            Icons.eco_outlined,
            size: 64,
            color: KiraColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'No verified green assets yet',
            style: KiraTypography.bodyMedium.copyWith(
              color: KiraColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload receipts for GITA-eligible purchases',
            style: KiraTypography.bodySmall.copyWith(
              color: KiraColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Hero section with tax savings - matching dashboard layout
  Widget _buildHeroSection(int savings, int change) {
    return Column(
      children: [
        SizedBox(height: KiraSpacing.heroTop),
        
        // Label - bigger, matching dashboard
        Text(
          'TOTAL TAX SAVED',
          style: KiraTypography.h4.copyWith(
            letterSpacing: 2,
            color: KiraColors.textSecondary,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Big number - matching dashboard
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              'RM ',
              style: KiraTypography.h3.copyWith(
                color: KiraColors.textTertiary,
              ),
            ),
            Text(
              _formatNumber(savings),
              style: KiraTypography.hero,
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Period selector - moved up, matching dashboard
        PeriodSelector(
          selected: _period,
          onChanged: (p) => setState(() => _period = p),
        ),
        
        SizedBox(height: KiraSpacing.heroBottom),
      ],
    );
  }
  
  Widget _buildGitaAssetsList(List receipts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GITA Eligible Assets',
          style: KiraTypography.h4,
        ),
        const SizedBox(height: 12),
        ...receipts.map((receipt) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: KiraCard(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: KiraColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.eco,
                    color: KiraColors.success,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        receipt.vendor,
                        style: KiraTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'RM ${receipt.gitaAllowance.toStringAsFixed(2)} tax savings',
                        style: KiraTypography.bodySmall.copyWith(
                          color: KiraColors.success,
                        ),
                      ),
                    ],
                  ),
                ),
                // Badge
                KiraBadge(
                  label: 'GITA',
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
  
  /// Info card about GITA
  Widget _buildInfoCard() {
    return KiraCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          const Icon(
            Icons.description_outlined,
            size: 18,
            color: KiraColors.success,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: KiraTypography.bodySmall.copyWith(
                  color: KiraColors.textSecondary,
                ),
                children: const [
                  TextSpan(
                    text: 'GITA: ',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(
                    text: '100% of asset cost can offset up to 70% of your statutory income.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
