import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  static const Color primaryColor = Color(0xFF1F4B43);
  static const Color secondaryColor = Color(0xFF63A088);
  static const Color accentColor = Color(0xFF53DD6C);
  static const Color backgroundColor = Color(0xFFF2F0F5);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color textColor = Color(0xFF2C2C2C);
  static const Color bodyTextColor = Color(0x8A000000);
  static const Color errorColor = Colors.redAccent;

  // ===========================================================================
  // THEME DATA (LIGHT MODE)
  // ===========================================================================

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: primaryColor,
    fontFamily: GoogleFonts.roboto().fontFamily,

    // --- Color Scheme ---
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      onPrimary: whiteColor,
      secondary: secondaryColor,
      onSecondary: whiteColor,
      surface: whiteColor,
      onSurface: textColor,
      error: errorColor,
      onError: whiteColor,
    ),

    // --- Text Theme ---
    textTheme: GoogleFonts.robotoTextTheme()
        .apply(bodyColor: textColor, displayColor: textColor)
        .copyWith(
          displaySmall: GoogleFonts.roboto(
            color: primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 36,
          ),
          headlineLarge: GoogleFonts.roboto(
            color: primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 32,
          ),
          headlineMedium: GoogleFonts.roboto(
            color: primaryColor,
            fontWeight: FontWeight.w700,
            fontSize: 28,
          ),
          titleMedium: GoogleFonts.roboto(
            color: primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          titleLarge: GoogleFonts.roboto(
            color: primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
          bodyLarge: GoogleFonts.roboto(color: bodyTextColor, fontSize: 16),
          bodyMedium: GoogleFonts.roboto(color: bodyTextColor, fontSize: 14),
          bodySmall: GoogleFonts.roboto(color: bodyTextColor, fontSize: 12),
        ),

    // --- Icon Theme ---
    iconTheme: IconThemeData(color: secondaryColor, size: 32),

    // --- Component Themes ---
    // Styling spesifik untuk widget.

    // AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: const IconThemeData(color: primaryColor),
      titleTextStyle: GoogleFonts.roboto(
        color: primaryColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),

    // Card
    cardTheme: CardThemeData(
      color: primaryColor,
      elevation: 2,
      shadowColor: primaryColor.withValues(alpha: 0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
    ),

    // ElevatedButton
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
        foregroundColor: whiteColor,
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.roboto(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: primaryColor,
      selectedItemColor: whiteColor,
      unselectedItemColor: whiteColor.withValues(alpha: 0.6),
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.roboto(fontWeight: FontWeight.w500),
      unselectedLabelStyle: GoogleFonts.roboto(),
    ),

    // Floating Action Button (FAB)
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: whiteColor,
      shape: CircleBorder(),
    ),

    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: GoogleFonts.roboto(
        color: accentColor, // Judul dialog menggunakan warna aksen.
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: GoogleFonts.roboto(color: whiteColor, fontSize: 15),
    ),
  );
}
