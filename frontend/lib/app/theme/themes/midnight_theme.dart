import 'package:flutter/material.dart';
import 'mirage_theme_data.dart';

/// "Midnight" aesthetic — cool, deep blues and silvers with a modern noir vibe.
class MidnightTheme extends MirageThemeData {
  final bool _isDark;
  MidnightTheme({bool isDark = false}) : _isDark = isDark;

  @override
  String get id => 'midnight';
  @override
  String get name => 'Midnight';
  @override
  String get description => 'Cool, deep blues & silvers — modern noir';
  @override
  Brightness get brightness => _isDark ? Brightness.dark : Brightness.light;

  // ─── Core Colors ─────────────────────────────────────────────────
  @override
  Color get primaryDark => const Color(0xFF0F1117);
  @override
  Color get primaryLight => const Color(0xFFE8EAF0);
  @override
  Color get accent => const Color(0xFF7C8CF8);
  @override
  Color get accentWarm => const Color(0xFF4A5278);
  @override
  Color get surface => _isDark ? const Color(0xFF1A1C24) : const Color(0xFFE8EAF0);
  @override
  Color get surfaceVariant =>
      _isDark ? const Color(0xFF2C2F3C) : const Color(0xFFB0B5C4);
  @override
  Color get textPrimary =>
      _isDark ? const Color(0xFFE8EAF0) : const Color(0xFF0F1117);
  @override
  Color get textSecondary =>
      _isDark ? const Color(0xFFB0B5C4) : const Color(0xFF7A7F8E);
  @override
  Color get textOnDark => const Color(0xFFE8EAF0);
  @override
  Color get textOnLight => const Color(0xFF0F1117);
  @override
  Color get error => const Color(0xFFFF6B6B);
  @override
  Color get success => const Color(0xFF00D1A0);

  // ─── Glass Properties ────────────────────────────────────────────
  @override
  Color get glassColor =>
      _isDark ? const Color(0x33000000) : const Color(0x33FFFFFF);
  @override
  Color get glassBorder =>
      _isDark ? const Color(0x1AFFFFFF) : const Color(0x1AFFFFFF);
  @override
  double get glassOpacity => _isDark ? 0.2 : 0.15;
  @override
  double get glassBlur => 24.0;

  // ─── Bevel Properties ────────────────────────────────────────────
  @override
  Color get bevelHighlight =>
      _isDark ? const Color(0x20FFFFFF) : const Color(0x30FFFFFF);
  @override
  Color get bevelShadow =>
      _isDark ? const Color(0x40000000) : const Color(0x20000000);
  @override
  double get bevelIntensity => 1.0;

  // ─── Backgrounds ─────────────────────────────────────────────────
  @override
  List<String> get backgroundAssets => const [
        'lib/images/backgrounds/4.jpg',
        'lib/images/backgrounds/5.jpg',
        'lib/images/backgrounds/6.jpg',
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
          Color(0x4D0F1117),
          Color(0x1A0F1117),
        ],
      );

  @override
  MirageThemeData toDark() => MidnightTheme(isDark: true);
  @override
  MirageThemeData toLight() => MidnightTheme(isDark: false);
}
