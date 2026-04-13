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
        scale: _isPressed ? 0.90 : 1.0, // Notion uses scale 0.9 for active state
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutQuart,
        child: Container(
          height: 48, // Notion uses slightly more compact button heights
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.isLoading ? AppTheme.primaryBlue.withOpacity(0.7) : AppTheme.primaryBlue,
            borderRadius: BorderRadius.circular(4), // Notion 4px micro radius
            border: Border.all(color: Colors.transparent, width: 1), // 1px transparent border per spec
          ),
          alignment: Alignment.center,
          child: widget.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                ).animate().fade()
              : Text(
                  widget.text, // No longer forced uppercase
                  style: Theme.of(context).textTheme.labelLarge, // White color provided by theme
                ),
        ),
      ),
    );
  }
}
