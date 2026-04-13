import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../controllers/auth_controller.dart';
import '../../../../constants/app_theme.dart';
import '../../../../utils/snackbar_utils.dart';

import '../../../../common_widgets/global_premium_widgets.dart';
import '../../../../exceptions/app_exception.dart'; // Clean Architecture Error Handler

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Hide keyboard
    FocusScope.of(context).unfocus();

    try {
      await ref.read(authControllerProvider.notifier).signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );
      // Success router redirect handles by app_router automatically!
    } catch (e) {
      if (!mounted) return;
      
      final mappedException = AppException.fromDio(e);
      SnackBarUtils.showError(context, mappedException.message);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 48),
                
                Text(
                  'Welcome\nBack!',
                  style: Theme.of(context).textTheme.displayLarge,
                ).animate().fade(duration: 600.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuart),
                
                const SizedBox(height: 12),
                
                Text(
                  'Sign in to reserve your spot and view events.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ).animate().fade(duration: 800.ms, delay: 200.ms),
                
                const SizedBox(height: 48),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter email';
                    final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                    if (!emailRegex.hasMatch(value)) return 'Please enter a valid email';
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
                  validator: (value) => value == null || value.isEmpty ? 'Please enter password' : null,
                  enabled: !isLoading,
                ).animate().fade(duration: 500.ms, delay: 500.ms).slideY(begin: 0.1),

                const SizedBox(height: 40),

                AnimatedPrimaryButton(
                  onPressed: _signIn,
                  text: 'Sign In',
                  isLoading: isLoading,
                ).animate().fade(duration: 500.ms, delay: 600.ms),
                
                const SizedBox(height: 24),
                
                Center(
                  child: TextButton(
                    onPressed: isLoading ? null : () => context.push('/register'),
                    child: RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          const TextSpan(text: "Don't have an account? "),
                          TextSpan(
                            text: 'Sign Up',
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
