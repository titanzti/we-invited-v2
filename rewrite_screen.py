import re

with open('lib/src/features/events/presentation/screens/create_event_screen.dart', 'r') as f:
    content = f.read()

# Replace _buildPremiumInput method usage with PremiumInputField widget
content = content.replace('_buildPremiumInput(', 'PremiumInputField(')

# Extract and remove _buildPremiumInput method
build_premium_regex = re.compile(r'  Widget _buildPremiumInput.*?\}\n\}\n', re.DOTALL)
content = build_premium_regex.sub('}\n', content)

# Add the PremiumInputField class at the bottom
widget_code = """
class PremiumInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;
  final String? Function(String?)? validator;

  const PremiumInputField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.validator,
  });

  @override
  State<PremiumInputField> createState() => _PremiumInputFieldState();
}

class _PremiumInputFieldState extends State<PremiumInputField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutQuart,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isFocused ? AppTheme.primaryBlue : AppTheme.borderLight,
          width: _isFocused ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: _isFocused
                ? AppTheme.primaryBlue.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: _isFocused ? 14 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        maxLines: widget.maxLines,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppTheme.textBody,
        ),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: const TextStyle(
            fontSize: 16,
            color: AppTheme.textMetadata,
            fontWeight: FontWeight.normal,
          ),
          prefixIcon: Column(
            mainAxisAlignment: widget.maxLines > 1 
                ? MainAxisAlignment.start 
                : MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(top: widget.maxLines > 1 ? 20 : 0),
                child: Icon(
                  widget.icon,
                  color: _isFocused ? AppTheme.primaryBlue : AppTheme.textBody,
                  size: 22,
                ),
              ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
        ),
        validator: widget.validator,
      ),
    );
  }
}
"""

content += widget_code

with open('lib/src/features/events/presentation/screens/create_event_screen.dart', 'w') as f:
    f.write(content)
