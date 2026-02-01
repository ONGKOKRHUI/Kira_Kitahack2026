/// Login Screen - Kira Design System
/// 
/// Premium login experience with gradient background and glassmorphism.
/// Uses Inter font (Google Fonts) matching the main app exactly.
library;

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/spacing.dart';
import '../../../providers/auth_providers.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool _isSignUpMode = false;
  String? _errorMessage;

  // Text styles using Inter font (same as main app)
  TextStyle get _titleStyle => GoogleFonts.inter(
    fontSize: 36,
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

  TextStyle get _linkStyle => GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: KiraColors.primary400,
  );

  TextStyle get _smallStyle => GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: KiraColors.textTertiary,
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> _signInWithEmail() async {
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.signInWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (user != null) {
        print('✅ Signed in as: ${user.email}');
      }
    } catch (e) {
      setState(() => _errorMessage = _parseFirebaseError(e.toString()));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signUpWithEmail() async {
    setState(() => _errorMessage = null);
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.signUpWithEmail(
        _emailController.text.trim(),
        _passwordController.text,
      );
      if (user != null) {
        print('✅ Account created: ${user.email}');
      }
    } catch (e) {
      setState(() => _errorMessage = _parseFirebaseError(e.toString()));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.signInWithGoogle();
      if (user == null) {
        setState(() => _isLoading = false);
        return;
      }
      print('✅ Signed in with Google: ${user.email}');
    } catch (e) {
      setState(() {
        _errorMessage = _parseFirebaseError(e.toString());
        _isLoading = false;
      });
    }
  }

  String _parseFirebaseError(String error) {
    if (error.contains('user-not-found')) return 'No account found with this email';
    if (error.contains('wrong-password')) return 'Incorrect password';
    if (error.contains('email-already-in-use')) return 'An account already exists with this email';
    if (error.contains('weak-password')) return 'Password is too weak (min 6 characters)';
    if (error.contains('invalid-email')) return 'Invalid email format';
    if (error.contains('network-request-failed')) return 'Network error. Please check your connection';
    return 'Authentication failed. Please try again';
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
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),
                      
                      // Logo
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: KiraColors.primary500.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: KiraColors.primary500.withOpacity(0.4),
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.eco,
                          size: 36,
                          color: KiraColors.primary500,
                        ),
                      ),
                      
                      const SizedBox(height: KiraSpacing.md),
                      
                      // Title
                      Text('Kira', style: _titleStyle),
                      
                      const SizedBox(height: 4),
                      
                      // Subtitle
                      Text(
                        _isSignUpMode ? 'Create your account' : 'Carbon Footprint Tracker',
                        style: _subtitleStyle,
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Main Card - more rounded (24px)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: KiraColors.bgCard,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: KiraColors.glassBorder),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Error Message
                                if (_errorMessage != null) ...[
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.error_outline, color: Colors.red, size: 16),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _errorMessage!,
                                            style: _smallStyle.copyWith(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                ],
                                
                                // Email Field
                                _buildTextField(
                                  controller: _emailController,
                                  label: 'Email',
                                  hint: 'your@email.com',
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _validateEmail,
                                ),
                                
                                const SizedBox(height: 14),
                                
                                // Password Field
                                _buildTextField(
                                  controller: _passwordController,
                                  label: 'Password',
                                  hint: '••••••••',
                                  icon: Icons.lock_outlined,
                                  obscureText: !_isPasswordVisible,
                                  validator: _validatePassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                      color: KiraColors.textTertiary,
                                      size: 18,
                                    ),
                                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                                  ),
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Primary Button with glow
                                _buildGlowingButton(
                                  label: _isSignUpMode ? 'Create Account' : 'Sign In',
                                  onPressed: _isLoading ? null : (_isSignUpMode ? _signUpWithEmail : _signInWithEmail),
                                  isLoading: _isLoading,
                                ),
                                
                                const SizedBox(height: 12),
                                
                                // Toggle Sign Up / Sign In
                                Center(
                                  child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _isSignUpMode = !_isSignUpMode;
                                        _errorMessage = null;
                                      });
                                    },
                                    child: Text(
                                      _isSignUpMode
                                          ? 'Already have an account? Sign In'
                                          : "Don't have an account? Sign Up",
                                      style: _linkStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Divider
                      Row(
                        children: [
                          Expanded(child: Divider(color: KiraColors.glassBorder)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('or', style: _smallStyle),
                          ),
                          Expanded(child: Divider(color: KiraColors.glassBorder)),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Google Sign-In Button
                      _buildGoogleButton(),
                      
                      const SizedBox(height: 32),
                      
                      // Security note
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.lock, size: 10, color: KiraColors.textTertiary),
                          const SizedBox(width: 4),
                          Text('Secured by Firebase', style: _smallStyle),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
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
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
    Widget? suffixIcon,
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
              keyboardType: keyboardType,
              obscureText: obscureText,
              validator: validator,
              style: _inputStyle,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: _inputStyle.copyWith(color: KiraColors.textTertiary),
                prefixIcon: Icon(icon, color: KiraColors.textTertiary, size: 18),
                suffixIcon: suffixIcon,
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
                  borderSide: BorderSide(color: KiraColors.primary500, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
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
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: KiraColors.primary500.withOpacity(0.5),
            blurRadius: 16,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: KiraColors.primary400.withOpacity(0.3),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  KiraColors.primary500,
                  KiraColors.primary600,
                ],
              ),
              borderRadius: BorderRadius.circular(14),
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
                  : Text(label, style: _buttonStyle),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: KiraColors.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: KiraColors.glassBorder),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isLoading ? null : _signInWithGoogle,
              borderRadius: BorderRadius.circular(14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Google logo from assets
                  Image.asset(
                    'assets/icons/Logo-google-icon-PNG.png',
                    width: 22,
                    height: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Continue with Google',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: KiraColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
