import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mirage_colors.dart';

/// Typography system for Mirage.
/// Edit font families and sizes here to adjust globally.
class MirageTypography {
  MirageTypography._();

  // ─── Font Family Getters (easy to swap) ─────────────────────────
  static String get displayFont => 'Playfair Display';
  static String get bodyFont => 'Manrope';
  static String get monoFont => 'Space Grotesk';

  // ─── Display Styles (Playfair Display — editorial/luxury) ───────
  static TextStyle displayLarge({Color color = MirageColors.stucco}) =>
      GoogleFonts.playfairDisplay(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        letterSpacing: 8,
        color: color,
      );

  static TextStyle displayMedium({Color color = MirageColors.stucco}) =>
      GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: 4,
        color: color,
      );

  static TextStyle displaySmall({Color color = MirageColors.stucco}) =>
      GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
        color: color,
      );

  // ─── Heading Styles (Manrope — clean, modern) ───────────────────
  static TextStyle headingLarge({Color color = MirageColors.onyx}) =>
      GoogleFonts.manrope(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: color,
      );

  static TextStyle headingMedium({Color color = MirageColors.onyx}) =>
      GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle headingSmall({Color color = MirageColors.onyx}) =>
      GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
      );

  // ─── Body Styles (Manrope) ──────────────────────────────────────
  static TextStyle bodyLarge({Color color = MirageColors.onyx}) =>
      GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      );

  static TextStyle bodyMedium({Color color = MirageColors.ash}) =>
      GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color,
      );

  static TextStyle bodySmall({Color color = MirageColors.ash}) =>
      GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
      );

  // ─── Label / Button Styles ──────────────────────────────────────
  static TextStyle labelLarge({Color color = MirageColors.stucco}) =>
      GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
        color: color,
      );

  static TextStyle labelSmall({Color color = MirageColors.ash}) =>
      GoogleFonts.spaceGrotesk(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
        color: color,
      );

  // ─── Caption / Mono ─────────────────────────────────────────────
  static TextStyle caption({Color color = MirageColors.ash}) =>
      GoogleFonts.spaceGrotesk(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        color: color,
      );

  static TextStyle price({Color color = MirageColors.onyx}) =>
      GoogleFonts.spaceGrotesk(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: color,
      );
}
