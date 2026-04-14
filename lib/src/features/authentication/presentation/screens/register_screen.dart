import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../controllers/auth_controller.dart';
import '../../../../constants/app_theme.dart';
import '../../../../utils/snackbar_utils.dart';
import '../../../../common_widgets/global_premium_widgets.dart';
import '../../../../exceptions/app_exception.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    
    FocusScope.of(context).unfocus();

    try {
      await ref.read(authControllerProvider.notifier).signUp(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );
      // Wait for AuthState to trigger router redirect!
    } catch (e) {
      if (!mounted) return;
      final mapped = AppException.fromDio(e);
      SnackBarUtils.showError(context, mapped.message);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                
                Text(
                  'Join the\nParty!',
                  style: Theme.of(context).textTheme.displayLarge,
                ).animate().fade(duration: 600.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuart),
                
                const SizedBox(height: 12),
                
                Text(
                  'Create an account to host or join amazing events around you.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ).animate().fade(duration: 800.ms, delay: 200.ms),
                
                const SizedBox(height: 48),

                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                  enabled: !isLoading,
                ).animate().fade(duration: 500.ms, delay: 300.ms).slideY(begin: 0.1),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    final email = value?.trim() ?? '';
                    if (email.isEmpty) return 'Please enter email';
                    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
                    if (!emailRegex.hasMatch(email)) return 'Please enter a valid email';
                    return null;
                  },
                  enabled: !isLoading,
                ).animate().fade(duration: 500.ms, delay: 400.ms).slideY(begin: 0.1),

                const SizedBox(height: 20),

                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter password';
                    if (value.length < 8) return 'Password must be at least 8 characters';
                    return null;
                  },
                  enabled: !isLoading,
                ).animate().fade(duration: 500.ms, delay: 500.ms).slideY(begin: 0.1),

                const SizedBox(height: 48),

                AnimatedPrimaryButton(
                  onPressed: _signUp,
                  text: 'Create Account',
                  isLoading: isLoading,
                ).animate().fade(duration: 500.ms, delay: 600.ms),
                
                const SizedBox(height: 24),
                
                Center(
                  child: TextButton(
                    onPressed: isLoading ? null : () => context.pop(),
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          const TextSpan(text: 'Already have an account? '),
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(
                              color: AppTheme.primaryBlue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ).animate().fade(duration: 500.ms, delay: 700.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
