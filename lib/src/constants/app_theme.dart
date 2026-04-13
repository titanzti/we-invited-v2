import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // Premium Color Palette
  static const Color primaryBlue = Color(0xFF2563EB); // Vibrant modern blue
  static const Color primaryDark = Color(0xFF0F172A); // Slate 900
  static const Color secondaryTeal = Color(0xFF0D9488);
  static const Color backgroundLight = Color(0xFFF8FAFC); // Slate 50
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color textBody = Color(0xFF334155); // Slate 700
  static const Color borderLight = Color(0xFFE2E8F0); // Slate 200
  static const Color error = Color(0xFFEF4444); // Red 500

  // Modern Typography applying 'Prompt' for Thai & English support
  static TextTheme get _premiumTextTheme {
    return GoogleFonts.promptTextTheme().copyWith(
      displayLarge: GoogleFonts.prompt(fontWeight: FontWeight.w700, color: primaryDark, letterSpacing: -1),
      displayMedium: GoogleFonts.prompt(fontWeight: FontWeight.w700, color: primaryDark, letterSpacing: -0.5),
      headlineLarge: GoogleFonts.prompt(fontWeight: FontWeight.w600, color: primaryDark),
      titleLarge: GoogleFonts.prompt(fontWeight: FontWeight.w600, color: primaryDark),
      bodyLarge: GoogleFonts.prompt(fontWeight: FontWeight.w400, color: textBody, fontSize: 16),
      bodyMedium: GoogleFonts.prompt(fontWeight: FontWeight.w400, color: textBody, fontSize: 14),
      labelLarge: GoogleFonts.prompt(fontWeight: FontWeight.w600, color: surfaceWhite, letterSpacing: 0.5),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: secondaryTeal,
        surface: surfaceWhite,
        error: Color(0xFFEF4444), // Red 500
        onPrimary: surfaceWhite,
      ),
      scaffoldBackgroundColor: backgroundLight,
      textTheme: _premiumTextTheme,
      useMaterial3: true,
      
      // Modern AppBar
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: surfaceWhite,
        foregroundColor: primaryDark,
        surfaceTintColor: Colors.transparent, // Remove Material 3 tint
      ),
      
      // Modern Elevated Button (Pill shaped, vibrant, scaled)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryBlue,
          foregroundColor: surfaceWhite,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.prompt(fontWeight: FontWeight.w600, fontSize: 16),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.white.withOpacity(0.1);
            }
            return null;
          }),
        ),
      ),
      
      // Modern Input Fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceWhite,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryBlue, width: 2),
        ),
        hintStyle: TextStyle(color: textBody.withOpacity(0.5)),
      ),
    );
  }
}

// Global Box Shadows for Premium Glass/Depth feel
class PremiumShadows {
  static List<BoxShadow> get softCard => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.02),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
}
