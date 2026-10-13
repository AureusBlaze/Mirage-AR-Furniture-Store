import 'package:flutter/material.dart';
import 'mirage_theme_data.dart';

/// Default theme — "Old Money" aesthetic.
/// Warm, luxurious, understated elegance.
class OldMoneyTheme extends MirageThemeData {
  final bool _isDark;
  OldMoneyTheme({bool isDark = false}) : _isDark = isDark;

  @override
  String get id => 'old_money';
  @override
  String get name => 'Old Money';
  @override
  String get description => 'Warm, luxurious, understated elegance';
  @override
  Brightness get brightness => _isDark ? Brightness.dark : Brightness.light;

  // ─── Core Colors ─────────────────────────────────────────────────
  @override
  Color get primaryDark => const Color(0xFF1C1C1B);
  @override
  Color get primaryLight => const Color(0xFFE2E2DE);
  @override
  Color get accent => const Color(0xFFF8BB73);
  @override
  Color get accentWarm => const Color(0xFF6A5D52);
  @override
  Color get surface => _isDark ? const Color(0xFF2A2926) : const Color(0xFFE2E2DE);
  @override
  Color get surfaceVariant =>
      _isDark ? const Color(0xFF403D37) : const Color(0xFFB7AC9B);
  @override
  Color get textPrimary =>
      _isDark ? const Color(0xFFE2E2DE) : const Color(0xFF1C1C1B);
  @override
  Color get textSecondary =>
      _isDark ? const Color(0xFFB7AC9B) : const Color(0xFF979086);
  @override
  Color get textOnDark => const Color(0xFFE2E2DE);
  @override
  Color get textOnLight => const Color(0xFF1C1C1B);
  @override
  Color get error => const Color(0xFFCF6679);
  @override
  Color get success => const Color(0xFF10B981);

  // ─── Glass Properties ────────────────────────────────────────────
  @override
  Color get glassColor =>
      _isDark ? const Color(0x33000000) : const Color(0x33FFFFFF);
  @override
  Color get glassBorder =>
      _isDark ? const Color(0x1AFFFFFF) : const Color(0x1AFFFFFF);
  @override
  double get glassOpacity => _isDark ? 0.25 : 0.2;
  @override
  double get glassBlur => 20.0;

  // ─── Bevel Properties ────────────────────────────────────────────
  @override
  Color get bevelHighlight =>
      _isDark ? const Color(0x22FFFFFF) : const Color(0x33FFFFFF);
  @override
  Color get bevelShadow =>
      _isDark ? const Color(0x44000000) : const Color(0x22000000);
  @override
  double get bevelIntensity => 1.0;

  // ─── Backgrounds ─────────────────────────────────────────────────
  @override
  List<String> get backgroundAssets => const [
        'lib/images/backgrounds/1.jpg',
        'lib/images/backgrounds/2.jpg',
        'lib/images/backgrounds/3.jpg',
      ];

  // ─── Gradients ───────────────────────────────────────────────────
  @override
  LinearGradient get overlayGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          primaryDark.withValues(alpha: 0.0),
          primaryDark.withValues(alpha: 0.8),
        ],
      );

  @override
  LinearGradient get cardGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0x4D1C1C1B),
          Color(0x1A1C1C1B),
        ],
      );

  @override
  MirageThemeData toDark() => OldMoneyTheme(isDark: true);
  @override
  MirageThemeData toLight() => OldMoneyTheme(isDark: false);
}
