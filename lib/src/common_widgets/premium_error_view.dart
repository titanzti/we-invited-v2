import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import 'global_premium_widgets.dart';

class PremiumErrorView extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onRetry;

  const PremiumErrorView({
    super.key,
    this.title = 'Oops!',
    this.message = 'Something went wrong. Please check your connection and try again.',
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.wifi_off_rounded,
              size: 64,
              color: AppTheme.error,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          AnimatedPrimaryButton(
            onPressed: onRetry,
            text: 'Try Again',
          )
        ],
      ),
    );
  }
}
