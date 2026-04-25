import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A premium animated button that slightly scales down when pressed
class AnimatedPrimaryButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;

  const AnimatedPrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
  });

  @override
  State<AnimatedPrimaryButton> createState() => _AnimatedPrimaryButtonState();
}

class _AnimatedPrimaryButtonState extends State<AnimatedPrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        if (widget.isLoading || widget.onPressed == null) return;
        setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        if (!widget.isLoading && widget.onPressed != null) {
          widget.onPressed!();
        }
      },
      onTapCancel: () {
        if (_isPressed) setState(() => _isPressed = false);
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.90 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutQuart,
        child: Container(
          height: 48,
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.isLoading
                ? AppTheme.primaryDark.withValues(alpha: 0.7)
                : AppTheme.primaryDark,
            borderRadius: BorderRadius.circular(99),
            boxShadow: widget.isLoading
                ? []
                : [
                    BoxShadow(
                      color: AppTheme.primaryDark.withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: AppTheme.surfaceWhite,
                    strokeWidth: 2,
                  ),
                ).animate().fade()
              : Text(
                  widget.text,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge,
                ),
        ),
      ),
    );
  }
}

/// A premium toast notification globally replacing Android's rigid SnackBar
class PremiumToast {
  static void show(
    BuildContext context,
    String title, {
    String? message,
    IconData? icon,
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();

    final toastIcon = icon ?? (isError ? Icons.error_outline : Icons.check_circle_rounded);
    final bgColor = isError ? AppTheme.error : AppTheme.primaryDark;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        margin: const EdgeInsets.only(bottom: 120, left: 16, right: 16),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: bgColor.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(toastIcon, color: AppTheme.surfaceWhite, size: 28),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppTheme.surfaceWhite,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.3,
                      ),
                    ),
                    if (message != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        message,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 13,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}

