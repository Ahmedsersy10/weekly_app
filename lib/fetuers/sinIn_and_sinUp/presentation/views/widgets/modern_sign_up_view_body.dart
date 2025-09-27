import 'package:flutter/material.dart';
import 'package:weekly_dash_board/core/utils/app_localizations.dart';
import 'package:weekly_dash_board/core/theme/app_theme.dart';
import 'package:weekly_dash_board/core/services/supabase_auth_service.dart';
import 'package:weekly_dash_board/fetuers/sinIn_and_sinUp/presentation/views/widgets/modern_auth_text_field.dart';
import 'package:weekly_dash_board/fetuers/sinIn_and_sinUp/presentation/views/widgets/modern_auth_button.dart';

class ModernSignUpViewBody extends StatefulWidget {
  const ModernSignUpViewBody({super.key});

  @override
  State<ModernSignUpViewBody> createState() => _ModernSignUpViewBodyState();
}

class _ModernSignUpViewBodyState extends State<ModernSignUpViewBody> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Full name must be at least 2 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain letters and numbers';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (!_acceptTerms) {
      _showSnackBar('Please accept the terms and conditions');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await SupabaseAuthService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _fullNameController.text.trim(),
      );

      if (response.user != null && mounted) {
        _showSnackBar(
          AppLocalizations.of(context).tr('auth.signUpSuccess'),
          isSuccess: true,
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = SupabaseAuthService.getErrorMessage(e);
        _showSnackBar(errorMessage);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: isSuccess 
          ? Colors.green.shade600 
          : Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 24 : 32,
          vertical: 16,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight - MediaQuery.of(context).padding.top - 100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              
              // Welcome Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create Account',
                    style: textTheme.displayMedium!.copyWith(
                      fontSize: AppTheme.getResponsiveFontSize(context, fontSize: 32),
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).tr('auth.signUpSubtitle'),
                    style: textTheme.bodyLarge!.copyWith(
                      fontSize: AppTheme.getResponsiveFontSize(context, fontSize: 16),
                      color: colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 48),

              // Sign Up Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    ModernAuthTextField(
                      label: 'Full Name',
                      hint: 'Enter your full name',
                      prefixIcon: Icons.person_outline,
                      controller: _fullNameController,
                      keyboardType: TextInputType.name,
                      validator: _validateFullName,
                      enabled: !_isLoading,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    ModernAuthTextField(
                      label: 'Email Address',
                      hint: 'Enter your email',
                      prefixIcon: Icons.email_outlined,
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      enabled: !_isLoading,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    ModernAuthTextField(
                      label: 'Password',
                      hint: 'Create a strong password',
                      prefixIcon: Icons.lock_outline,
                      controller: _passwordController,
                      obscureText: true,
                      validator: _validatePassword,
                      enabled: !_isLoading,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    ModernAuthTextField(
                      label: 'Confirm Password',
                      hint: 'Confirm your password',
                      prefixIcon: Icons.lock_outline,
                      controller: _confirmPasswordController,
                      obscureText: true,
                      validator: _validateConfirmPassword,
                      enabled: !_isLoading,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Terms and Conditions Checkbox
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _acceptTerms,
                          onChanged: _isLoading ? null : (value) {
                            setState(() {
                              _acceptTerms = value ?? false;
                            });
                          },
                          activeColor: colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: RichText(
                              text: TextSpan(
                                text: 'I agree to the ',
                                style: textTheme.bodyMedium!.copyWith(
                                  color: colorScheme.onSurface.withOpacity(0.7),
                                  fontSize: AppTheme.getResponsiveFontSize(context, fontSize: 14),
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Terms of Service',
                                    style: textTheme.bodyMedium!.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: AppTheme.getResponsiveFontSize(context, fontSize: 14),
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' and ',
                                    style: textTheme.bodyMedium!.copyWith(
                                      color: colorScheme.onSurface.withOpacity(0.7),
                                      fontSize: AppTheme.getResponsiveFontSize(context, fontSize: 14),
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: textTheme.bodyMedium!.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: AppTheme.getResponsiveFontSize(context, fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Sign Up Button
                    ModernAuthButton(
                      text: 'Create Account',
                      onPressed: _handleSignUp,
                      isLoading: _isLoading,
                      icon: Icons.person_add,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Sign In Link
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: 'Already have an account? ',
                    style: textTheme.bodyMedium!.copyWith(
                      color: colorScheme.onSurface.withOpacity(0.7),
                      fontSize: AppTheme.getResponsiveFontSize(context, fontSize: 14),
                    ),
                    children: [
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: _isLoading ? null : () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Sign In',
                            style: textTheme.bodyMedium!.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              fontSize: AppTheme.getResponsiveFontSize(context, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
