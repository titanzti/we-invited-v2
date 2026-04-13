import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';


/// A premium animated button that slightly scales down when pressed
class AnimatedPrimaryButton extends StatefulWidget {
  final VoidCallback onPressed;
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
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        if (!widget.isLoading) {
          widget.onPressed();
        }
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutQuart,
        child: Container(
          height: 56,
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.isLoading ? AppTheme.primaryBlue.withOpacity(0.7) : AppTheme.primaryBlue,
            borderRadius: BorderRadius.circular(16),
            boxShadow: _isPressed ? [] : PremiumShadows.softCard,
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                ).animate().fade()
              : Text(
                  widget.text,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
        ),
      ),
    );
  }
}
