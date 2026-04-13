import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // Notion Color Palette
  static const Color primaryBlue = Color(0xFF0075DE); // Notion Blue (CTA)
  static const Color primaryDark = Color(0xF2000000); // rgba(0,0,0,0.95)
  static const Color secondaryTeal = Color(0xFF2A9D99); // Semantic Teal
  static const Color backgroundLight = Color(0xFFF6F5F4); // Warm White
  static const Color surfaceWhite = Color(0xFFFFFFFF); // Pure White
  static const Color textBody = Color(0xF2000000); // rgba(0,0,0,0.95)
  static const Color textMetadata = Color(0xFF615D59); // Warm Gray 500
  static const Color borderLight = Color(0x19000000); // rgba(0,0,0,0.1) 'Whisper'
  static const Color error = Color(0xFFDD5B00); // Orange/Red warning

  // Dark mode palette
  static const Color darkBackground = Color(0xFF191919);
  static const Color darkSurface = Color(0xFF252525);
  static const Color darkBorder = Color(0x33FFFFFF);
  static const Color darkTextPrimary = Color(0xFFE8E6E3);
  static const Color darkTextSecondary = Color(0xFF9B9A97);

  // Notion Typography (Inter with specific tracking)
  static TextTheme _premiumTextTheme({bool isDark = false}) {
    final primary = isDark ? darkTextPrimary : primaryDark;
    final body = isDark ? darkTextPrimary : textBody;

    return GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(fontWeight: FontWeight.w700, color: primary, fontSize: 64, height: 1.0, letterSpacing: -2.125),
      displayMedium: GoogleFonts.inter(fontWeight: FontWeight.w700, color: primary, fontSize: 54, height: 1.04, letterSpacing: -1.875),
      headlineLarge: GoogleFonts.inter(fontWeight: FontWeight.w700, color: primary, fontSize: 40, height: 1.5, letterSpacing: 0),
      titleLarge: GoogleFonts.inter(fontWeight: FontWeight.w700, color: primary, fontSize: 26, height: 1.23, letterSpacing: -0.625),
      titleMedium: GoogleFonts.inter(fontWeight: FontWeight.w700, color: primary, fontSize: 22, height: 1.27, letterSpacing: -0.25),
      bodyLarge: GoogleFonts.inter(fontWeight: FontWeight.w400, color: body, fontSize: 16, height: 1.5, letterSpacing: 0),
      bodyMedium: GoogleFonts.inter(fontWeight: FontWeight.w500, color: body, fontSize: 16, height: 1.5, letterSpacing: 0),
      labelLarge: GoogleFonts.inter(fontWeight: FontWeight.w600, color: surfaceWhite, fontSize: 15, height: 1.33, letterSpacing: 0),
      labelSmall: GoogleFonts.inter(fontWeight: FontWeight.w600, color: primaryBlue, fontSize: 12, height: 1.33, letterSpacing: 0.125),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: secondaryTeal,
        surface: surfaceWhite,
        error: error,
        onPrimary: surfaceWhite,
      ),
      scaffoldBackgroundColor: backgroundLight,
      textTheme: _premiumTextTheme(),
      useMaterial3: true,
      
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: backgroundLight,
        foregroundColor: primaryDark,
        surfaceTintColor: Colors.transparent,
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryBlue,
          foregroundColor: surfaceWhite,
          minimumSize: const Size(double.infinity, 56),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15, height: 1.33),
        ).copyWith(
          overlayColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return const Color(0xFF005BAB);
            }
            return null;
          }),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceWhite,
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFDDDDDD), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFFDDDDDD), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFF097FE8), width: 2),
        ),
        hintStyle: GoogleFonts.inter(color: const Color(0xFFA39E98)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: primaryBlue,
        secondary: secondaryTeal,
        surface: darkSurface,
        error: error,
        onPrimary: surfaceWhite,
        onSurface: darkTextPrimary,
      ),
      scaffoldBackgroundColor: darkBackground,
      textTheme: _premiumTextTheme(isDark: true),
      useMaterial3: true,

      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: darkBackground,
        foregroundColor: darkTextPrimary,
        surfaceTintColor: Colors.transparent,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryBlue,
          foregroundColor: surfaceWhite,
          minimumSize: const Size(double.infinity, 56),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15, height: 1.33),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFF3E3E3E), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFF3E3E3E), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFF097FE8), width: 2),
        ),
        hintStyle: GoogleFonts.inter(color: darkTextSecondary),
      ),

      cardTheme: const CardThemeData(
        color: darkSurface,
        elevation: 0,
      ),
    );
  }
}

// Flat Design strictly outlaws visual drop shadows
class PremiumShadows {
  // Notion's Ambient 4-layer soft stack
  static List<BoxShadow> get softCard => [
    const BoxShadow(
      color: Color(0x0A000000), // 0.04
      blurRadius: 18,
      offset: Offset(0, 4),
    ),
    const BoxShadow(
      color: Color(0x07000000), // 0.027
      blurRadius: 7.85,
      offset: Offset(0, 2),
    ),
    const BoxShadow(
      color: Color(0x05000000), // 0.02
      blurRadius: 2.93,
      offset: Offset(0, 0.8),
    ),
    const BoxShadow(
      color: Color(0x03000000), // 0.01
      blurRadius: 1.04,
      offset: Offset(0, 0.175),
    ),
  ];
}
