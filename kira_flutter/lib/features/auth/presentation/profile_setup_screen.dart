/// Profile Setup Screen - Kira Design System
/// 
/// Premium profile setup with gradient background and glassmorphism.
/// Uses Inter font (Google Fonts) matching the main app exactly.
library;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/spacing.dart';
import '../../../data/models/user_profile.dart';
import '../../../providers/auth_providers.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _regNumberController = TextEditingController();
  final _addressController = TextEditingController();
  String? _industry;
  String? _companySize;
  bool _isLoading = false;

  // Text styles using Inter font (same as main app)
  TextStyle get _headerStyle => GoogleFonts.inter(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: KiraColors.textPrimary,
  );

  TextStyle get _subtitleStyle => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: KiraColors.textSecondary,
  );

  TextStyle get _labelStyle => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: KiraColors.textSecondary,
  );

  TextStyle get _inputStyle => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: KiraColors.textPrimary,
  );

  TextStyle get _buttonStyle => GoogleFonts.inter(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  TextStyle get _smallStyle => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: KiraColors.textTertiary,
  );

  final List<String> _industries = [
    'Manufacturing',
    'Technology',
    'Retail',
    'Food & Beverage',
    'Construction',
    'Transportation',
    'Healthcare',
    'Other',
  ];

  final List<String> _companySizes = [
    '1-10 employees',
    '11-50 employees',
    '51-200 employees',
    '201-500 employees',
    '500+ employees',
  ];

  @override
  void dispose() {
    _companyNameController.dispose();
    _regNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = ref.read(currentUserProvider).value;
      if (user == null) throw Exception('Not authenticated');

      final profile = UserProfile(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? 'User',
        photoUrl: user.photoURL,
        companyName: _companyNameController.text,
        industry: _industry,
        companySize: _companySize,
        country: 'Malaysia',
        regNumber: _regNumberController.text.isEmpty ? null : _regNumberController.text,
        companyAddress: _addressController.text.isEmpty ? null : _addressController.text,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final service = ref.read(userProfileServiceProvider);
      await service.saveProfile(profile);

      print('✅ Profile saved');
    } catch (e) {
      setState(() => _isLoading = false);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _goBack() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: KiraColors.bgCardSolid,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text('Go Back?', style: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: KiraColors.textPrimary,
        )),
        content: Text(
          'You need to complete your company profile to use Kira. Going back will sign you out.',
          style: _subtitleStyle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: TextStyle(color: KiraColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    
    if (confirmed == true) {
      final authService = ref.read(authServiceProvider);
      await authService.signOut();
    }
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
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button - more rounded
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: KiraColors.bgCard,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: KiraColors.glassBorder),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, size: 20),
                              onPressed: _goBack,
                              color: KiraColors.textPrimary,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Header - bigger font
                      Text('Tell us about your company', style: _headerStyle),
                      const SizedBox(height: 6),
                      Text(
                        'This helps us calculate emissions accurately',
                        style: _subtitleStyle,
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Main Card - more rounded (24px)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: KiraColors.bgCard,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: KiraColors.glassBorder),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Company Name
                                _buildTextField(
                                  controller: _companyNameController,
                                  label: 'Company Name *',
                                  hint: 'e.g., Acme Industries Sdn Bhd',
                                  icon: Icons.business,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Required';
                                    }
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 14),
                                
                                // Registration Number (optional)
                                _buildTextField(
                                  controller: _regNumberController,
                                  label: 'Registration Number',
                                  hint: 'e.g., 202301012345',
                                  icon: Icons.numbers,
                                ),
                                
                                const SizedBox(height: 14),
                                
                                // Industry Dropdown
                                _buildDropdown(
                                  label: 'Industry *',
                                  value: _industry,
                                  items: _industries,
                                  icon: Icons.factory,
                                  onChanged: (value) => setState(() => _industry = value),
                                  validator: (value) {
                                    if (value == null) return 'Required';
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 14),
                                
                                // Company Size Dropdown
                                _buildDropdown(
                                  label: 'Company Size *',
                                  value: _companySize,
                                  items: _companySizes,
                                  icon: Icons.people,
                                  onChanged: (value) => setState(() => _companySize = value),
                                  validator: (value) {
                                    if (value == null) return 'Required';
                                    return null;
                                  },
                                ),
                                
                                const SizedBox(height: 14),
                                
                                // Address (optional)
                                _buildTextField(
                                  controller: _addressController,
                                  label: 'Company Address',
                                  hint: 'e.g., 123 Jalan Industri',
                                  icon: Icons.location_on,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 28),
                      
                      // Submit Button - centered with glow
                      Center(
                        child: _buildGlowingButton(
                          label: 'Complete Setup',
                          onPressed: _isLoading ? null : _saveProfile,
                          isLoading: _isLoading,
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Info text
                      Center(
                        child: Text('You can update this later', style: _smallStyle),
                      ),
                      
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: TextFormField(
              controller: controller,
              validator: validator,
              style: _inputStyle,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: _inputStyle.copyWith(color: KiraColors.textTertiary),
                prefixIcon: Icon(icon, color: KiraColors.textTertiary, size: 18),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: KiraColors.glassBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: KiraColors.glassBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: KiraColors.primary500, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: DropdownButtonFormField<String>(
              value: value,
              onChanged: onChanged,
              validator: validator,
              dropdownColor: KiraColors.bgCardSolid,
              style: _inputStyle,
              icon: Icon(Icons.keyboard_arrow_down, color: KiraColors.textTertiary, size: 20),
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: KiraColors.textTertiary, size: 18),
                filled: true,
                fillColor: Colors.white.withOpacity(0.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: KiraColors.glassBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: KiraColors.glassBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: KiraColors.primary500, width: 1.5),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
              items: items.map((item) => DropdownMenuItem(
                value: item,
                child: Text(item, style: _inputStyle),
              )).toList(),
            ),
          ),
        ),
      ],
    );
  }

  // Glowing button like AI chat button
  Widget _buildGlowingButton({
    required String label,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: KiraColors.primary500.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: KiraColors.primary400.withOpacity(0.3),
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 36),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  KiraColors.primary500,
                  KiraColors.primary600,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(label, style: _buttonStyle),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
