import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'themes/mirage_theme_data.dart';

/// Builds a Material [ThemeData] from a [MirageThemeData].
/// Bridges custom Mirage design tokens to Flutter's theming system.
/// Buttons use solid accent-complementary colors.
class MirageTheme {
  MirageTheme._();

  static ThemeData fromMirageTheme(MirageThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      brightness: theme.brightness,
      scaffoldBackgroundColor: theme.surface,
      colorScheme: ColorScheme(
        brightness: theme.brightness,
        primary: theme.primaryDark,
        onPrimary: theme.textOnDark,
        secondary: theme.accentWarm,
        onSecondary: theme.textOnDark,
        tertiary: theme.accent,
        onTertiary: theme.primaryDark,
        surface: theme.surface,
        onSurface: theme.textPrimary,
        surfaceContainerHighest: theme.surfaceVariant,
        error: theme.error,
        onError: Colors.white,
      ),
      textTheme: _buildTextTheme(theme),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 4,
          color: theme.textOnDark,
        ),
        iconTheme: IconThemeData(color: theme.textOnDark),
      ),
      // Solid accent-colored elevated buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.accentWarm,
          foregroundColor: theme.textOnDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
      ),
      // Solid outlined buttons with accent border
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.textOnDark,
          side: BorderSide(color: theme.accentWarm),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: theme.accent,
          textStyle: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? theme.surfaceVariant.withValues(alpha: 0.3)
            : theme.surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.surfaceVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
              color: theme.surfaceVariant.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.accent, width: 1.5),
        ),
        hintStyle: GoogleFonts.manrope(
          color: theme.textSecondary,
          fontSize: 14,
        ),
      ),
      cardTheme: CardThemeData(
        color: theme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? theme.primaryDark : theme.surface,
        selectedItemColor: theme.accent,
        unselectedItemColor: theme.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerTheme: DividerThemeData(
        color: theme.surfaceVariant.withValues(alpha: 0.3),
        thickness: 0.5,
      ),
      iconTheme: IconThemeData(
        color: theme.textSecondary,
        size: 22,
      ),
    );
  }

  static TextTheme _buildTextTheme(MirageThemeData theme) {
    return TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        letterSpacing: 8,
        color: theme.textPrimary,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: 4,
        color: theme.textPrimary,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
        color: theme.textPrimary,
      ),
      headlineLarge: GoogleFonts.manrope(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: theme.textPrimary,
      ),
      headlineMedium: GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: theme.textPrimary,
      ),
      headlineSmall: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: theme.textPrimary,
      ),
      bodyLarge: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: theme.textPrimary,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: theme.textSecondary,
      ),
      bodySmall: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: theme.textSecondary,
      ),
      labelLarge: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
        color: theme.textPrimary,
      ),
      labelSmall: GoogleFonts.spaceGrotesk(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
        color: theme.textSecondary,
      ),
    );
  }
}
