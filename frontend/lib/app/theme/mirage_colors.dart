import 'package:flutter/material.dart';

/// Central color tokens for the Mirage design system.
/// Edit these values to adjust the entire application's palette.
class MirageColors {
  MirageColors._();

  // ─── Primary Palette (from Color Scheme) ─────────────────────────
  static const Color onyx = Color(0xFF1C1C1B);
  static const Color walnut = Color(0xFF6A5D52);
  static const Color greige = Color(0xFFB7AC9B);
  static const Color ash = Color(0xFF979086);
  static const Color stucco = Color(0xFFE2E2DE);

  // ─── Accent / Functional ─────────────────────────────────────────
  static const Color amber = Color(0xFFF8BB73);
  static const Color emerald = Color(0xFF10B981);
  static const Color error = Color(0xFFCF6679);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  // ─── Glass Surfaces ──────────────────────────────────────────────
  static const Color glassWhite = Color(0x33FFFFFF); // 20% white
  static const Color glassDark = Color(0x661C1C1B);  // 40% onyx
  static const Color glassBorder = Color(0x1AFFFFFF); // 10% white

  // ─── Gradients ───────────────────────────────────────────────────
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x001C1C1B),
      Color(0xCC1C1C1B),
    ],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x4D1C1C1B),
      Color(0x1A1C1C1B),
    ],
  );
}
