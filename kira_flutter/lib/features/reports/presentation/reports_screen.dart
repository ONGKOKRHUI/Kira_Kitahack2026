/// Reports Screen
/// 
/// Carbon report generation with company profile, filters, receipt selection.
/// Matches React Reports.jsx.
library;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/spacing.dart';
import '../../../core/constants/typography.dart';
import '../../../shared/widgets/kira_card.dart';
import '../../../shared/widgets/kira_button.dart';
import '../../../shared/widgets/kira_badge.dart';
import '../../../providers/auth_providers.dart';

/// Reports screen implementation
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileStreamProvider);
    
    return profileAsync.when(
      data: (profile) {
        if (profile == null) {
          return const Center(child: Text('No profile found'));
        }
        
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              
              // Title - matching Scan page
              Text('Carbon Report', style: KiraTypography.h3),
              const SizedBox(height: 6),
              Text(
                'Generate GHG Protocol compliant report',
                style: KiraTypography.bodySmall.copyWith(
                  color: KiraColors.textSecondary,
                ),
              ),
              
              const SizedBox(height: 14),
              
              // Company Profile Card
              _buildProfileCard(profile),
              
              const SizedBox(height: 40),
              
              // Empty state for receipts
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 48,
                      color: KiraColors.textTertiary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No receipts yet',
                      style: KiraTypography.bodyMedium.copyWith(
                        color: KiraColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Upload receipts to generate reports',
                      style: KiraTypography.bodySmall.copyWith(
                        color: KiraColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: KiraSpacing.screenBottom),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  /// Company profile card
  Widget _buildProfileCard(profile) {
    return GestureDetector(
      onTap: () => _showEditProfileDialog(profile),
      child: KiraCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: KiraColors.success.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.business_outlined,
                size: 20,
                color: KiraColors.success,
              ),
            ),
            const SizedBox(width: 12),
            
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.companyName,
                    style: KiraTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${profile.industry ?? 'No industry'} • ${profile.companySize ?? 'Unknown size'}',
                    style: KiraTypography.labelSmall,
                  ),
                ],
              ),
            ),
            
            // Chevron
            Icon(
              Icons.chevron_right,
              size: 18,
              color: KiraColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  /// Show edit profile dialog with glassmorphism
  void _showEditProfileDialog(profile) {
    final formKey = GlobalKey<FormState>();
    final companyNameController = TextEditingController(text: profile.companyName);
    final regNumberController = TextEditingController(text: profile.regNumber ?? '');
    final addressController = TextEditingController(text: profile.companyAddress ?? '');
    String? industry = profile.industry;
    String? companySize = profile.companySize;
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  KiraColors.success.withOpacity(0.15),
                  Colors.white.withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: KiraColors.success.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: KiraColors.success.withOpacity(0.1),
                  blurRadius: 40,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            'Edit Company Profile',
                            style: KiraTypography.h3.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 16),
                          
                          // Company Name
                          _buildTextField(
                            controller: companyNameController,
                            label: 'Company Name *',
                            validator: (v) => v?.isEmpty == true ? 'Required' : null,
                          ),
                          const SizedBox(height: 10),
                          
                          // Registration Number
                          _buildTextField(
                            controller: regNumberController,
                            label: 'SSM Registration No.',
                          ),
                          const SizedBox(height: 10),
                          
                          // Company Address
                          _buildTextField(
                            controller: addressController,
                            label: 'Company Address',
                            maxLines: 2,
                          ),
                          const SizedBox(height: 10),
                          
                          // Industry
                          _buildDropdown(
                            value: industry,
                            label: 'Industry',
                            items: [
                              'Manufacturing',
                              'Technology',
                              'Retail',
                              'Services',
                              'Hospitality',
                              'Healthcare',
                              'Education',
                              'Construction',
                              'Other',
                            ],
                            onChanged: (value) => setState(() => industry = value),
                          ),
                          const SizedBox(height: 10),
                          
                          // Company Size
                          _buildDropdown(
                            value: companySize,
                            label: 'Company Size',
                            items: [
                              '1-10 employees',
                              '11-50 employees',
                              '51-200 employees',
                              '201-500 employees',
                              '500+ employees',
                            ],
                            onChanged: (value) => setState(() => companySize = value),
                          ),
                          const SizedBox(height: 20),
                          
                          // Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // Cancel Button
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                ),
                                child: Text(
                                  'Cancel',
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              const SizedBox(width: 8),
                              
                              // Save Button with glow
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: KiraColors.primary500.withOpacity(0.5),
                                      blurRadius: 20,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () async {
                                          if (!formKey.currentState!.validate()) return;
                                          
                                          setState(() => isLoading = true);
                                          
                                          try {
                                            final updatedProfile = profile.copyWith(
                                              companyName: companyNameController.text,
                                              regNumber: regNumberController.text.isEmpty ? null : regNumberController.text,
                                              companyAddress: addressController.text.isEmpty ? null : addressController.text,
                                              industry: industry,
                                              companySize: companySize,
                                              updatedAt: DateTime.now(),
                                            );
                                            
                                            final service = ref.read(userProfileServiceProvider);
                                            await service.saveProfile(updatedProfile);
                                            
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(content: Text('Profile updated!')),
                                              );
                                            }
                                          } catch (e) {
                                            setState(() => isLoading = false);
                                            if (context.mounted) {
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Failed: $e'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: KiraColors.primary500,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation(Colors.white),
                                          ),
                                        )
                                      : Text('Save', style: const TextStyle(fontSize: 13)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper to build text field with smaller fonts
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: KiraColors.primary500, width: 1.5),
        ),
      ),
    );
  }

  // Helper to build dropdown with smaller fonts
  Widget _buildDropdown({
    required String? value,
    required String label,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      style: const TextStyle(fontSize: 13, color: KiraColors.text900),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 12),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
      ),
      items: items.map((item) => DropdownMenuItem(
        value: item,
        child: Text(item, style: const TextStyle(fontSize: 13)),
      )).toList(),
      onChanged: onChanged,
    );
  }
}
