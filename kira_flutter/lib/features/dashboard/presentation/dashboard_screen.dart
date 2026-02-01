/// Dashboard Screen
/// 
/// Main home screen showing emissions overview, scope breakdown,
/// and trend chart. Uses real receipt data.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/spacing.dart';
import '../../../core/constants/typography.dart';
import '../../../shared/widgets/kira_card.dart';
import '../../../shared/widgets/period_selector.dart';
import '../../../providers/receipt_providers.dart';

/// Dashboard screen implementation
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  String _period = 'Year';
  
  /// Calculate monthly trend data from receipts
  List<Map<String, dynamic>> _calculateMonthlyTrend(List receipts) {
    final now = DateTime.now();
    final months = ['Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final monthData = <String, double>{};
    
    // Initialize all months to 0
    for (var month in months) {
      monthData[month] = 0;
    }
    
    // Sum up CO2 by month
    for (final receipt in receipts) {
      final monthIndex = receipt.date.month - 1;
      final year = receipt.date.year;
      
      // Only include receipts from last 6 months
      final monthsAgo = (now.year - year) * 12 + (now.month - receipt.date.month);
      if (monthsAgo >= 0 && monthsAgo < 6) {
        final monthName = _getMonthName(monthIndex);
        monthData[monthName] = (monthData[monthName] ?? 0) + receipt.co2Kg;
      }
    }
    
    return months.map((month) => {
      'month': month,
      'value': monthData[month] ?? 0,
    }).toList();
  }
  
  String _getMonthName(int index) {
    const monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return monthNames[index];
  }

  @override
  Widget build(BuildContext context) {
    print('🎨 Dashboard Build Called');
    final receiptsAsync = ref.watch(receiptsStreamProvider);
    
    return receiptsAsync.when(
      data: (receipts) {
        print('📊 Dashboard Data Loaded: ${receipts.length} receipts');
        
        // Calculate total CO2 in kg
        final totalCO2 = receipts.fold(0.0, (sum, r) => sum + r.co2Kg);
        
        // Calculate scope data from real receipts in kg
        final scope1Total = receipts.where((r) => r.scope == 1).fold(0.0, (sum, r) => sum + r.co2Kg);
        final scope2Total = receipts.where((r) => r.scope == 2).fold(0.0, (sum, r) => sum + r.co2Kg);
        final scope3Total = receipts.where((r) => r.scope == 3).fold(0.0, (sum, r) => sum + r.co2Kg);
        
        final scopeData = [
          if (scope1Total > 0) {'name': 'Scope 1', 'value': scope1Total, 'color': KiraColors.scope1, 'label': 'Direct'},
          if (scope2Total > 0) {'name': 'Scope 2', 'value': scope2Total, 'color': KiraColors.scope2, 'label': 'Electricity'},
          if (scope3Total > 0) {'name': 'Scope 3', 'value': scope3Total, 'color': KiraColors.scope3, 'label': 'Supply Chain'},
        ];
        
        final totalScope = scope1Total + scope2Total + scope3Total;
        final trendData = _calculateMonthlyTrend(receipts);
    
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section
              _buildHeroSection(totalCO2),
              
              const SizedBox(height: 24),
              
              // Scope Breakdown
              _buildScopeBreakdown(totalScope, scopeData),
              
              const SizedBox(height: 20),
              
              // Trend Chart
              _buildTrendChart(trendData),
              
              const SizedBox(height: 20),
              
              // Key Metrics
              _buildKeyMetrics(receipts.length),
              
              const SizedBox(height: KiraSpacing.screenBottom),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
  
  /// Hero section with large emissions number
  Widget _buildHeroSection(double emissions) {
    return Column(
      children: [
        SizedBox(height: KiraSpacing.heroTop),
        
        // Label - bigger
        Text(
          'TOTAL CO₂ EMITTED',
          style: KiraTypography.h4.copyWith(
            letterSpacing: 2,
            color: KiraColors.textSecondary,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Big number in kg - slightly smaller
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              emissions.toStringAsFixed(0),
              style: KiraTypography.hero,
            ),
            const SizedBox(width: 6),
            Text(
              'kg',
              style: KiraTypography.h3.copyWith(
                color: KiraColors.textTertiary,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Period selector - moved up
        PeriodSelector(
          selected: _period,
          onChanged: (p) => setState(() => _period = p),
        ),
        
        SizedBox(height: KiraSpacing.heroBottom),
      ],
    );
  }
  
  /// Scope breakdown with pie chart
  Widget _buildScopeBreakdown(double total, List<Map<String, dynamic>> scopeData) {
    if (scopeData.isEmpty) {
      return KiraCard(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'No emissions data yet',
              style: KiraTypography.bodyMedium.copyWith(
                color: KiraColors.textSecondary,
              ),
            ),
          ),
        ),
      );
    }
    
    return KiraCard(
      child: Column(
        children: [
          Row(
            children: [
              // Pie chart
              SizedBox(
                width: 100,
                height: 100,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 35,
                    sections: scopeData.map((scope) {
                      return PieChartSectionData(
                        value: (scope['value'] as double),
                        color: scope['color'] as Color,
                        radius: 15,
                        showTitle: false,
                      );
                    }).toList(),
                  ),
                ),
              ),
              
              const SizedBox(width: 20),
              
              // Legend
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: scopeData.map((scope) {
                    final percentage = total > 0 ? ((scope['value'] as double) / total * 100).round() : 0;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: scope['color'] as Color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              scope['label'] as String,
                              style: KiraTypography.labelSmall,
                            ),
                          ),
                          Text(
                            '$percentage%',
                            style: KiraTypography.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  /// Monthly trend line chart
  Widget _buildTrendChart(List<Map<String, dynamic>> trendData) {
    return KiraCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MONTHLY TREND',
            style: KiraTypography.caption,
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < trendData.length) {
                          return Text(
                            trendData[value.toInt()]['month'] as String,
                            style: KiraTypography.micro,
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: trendData.asMap().entries.map((e) {
                      return FlSpot(e.key.toDouble(), e.value['value'] as double);
                    }).toList(),
                    isCurved: true,
                    color: KiraColors.primary500,
                    barWidth: 2,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          KiraColors.primary500.withOpacity(0.3),
                          KiraColors.primary500.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Key metrics grid
  Widget _buildKeyMetrics(int receiptCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'KEY METRICS',
          style: KiraTypography.sectionTitle,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildMetricCard('GITA Saved', 'RM 0', Icons.eco)),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricCard('Carbon Tax', 'RM 0', Icons.account_balance)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _buildMetricCard('Receipts', '$receiptCount', Icons.receipt_long)),
            const SizedBox(width: 10),
            Expanded(child: _buildMetricCard('Grid Factor', '0.538', Icons.bolt)),
          ],
        ),
      ],
    );
  }
  
  Widget _buildMetricCard(String label, String value, IconData icon) {
    return KiraCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: KiraColors.primary500.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: KiraColors.primary500),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: KiraTypography.labelSmall),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: KiraTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
