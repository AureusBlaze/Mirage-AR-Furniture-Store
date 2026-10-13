import 'package:flutter/material.dart';
import 'mirage_theme_data.dart';

/// "Champagne Rosé" aesthetic — blush pinks, warm golds, feminine opulence.
class ChampagneRoseTheme extends MirageThemeData {
  final bool _isDark;
  ChampagneRoseTheme({bool isDark = false}) : _isDark = isDark;

  @override
  String get id => 'champagne_rose';
  @override
  String get name => 'Champagne Rosé';
  @override
  String get description => 'Blush pinks & warm golds — feminine opulence';
  @override
  Brightness get brightness => _isDark ? Brightness.dark : Brightness.light;

  @override
  Color get primaryDark => const Color(0xFF2A2024);
  @override
  Color get primaryLight => const Color(0xFFF5EBF0);
  @override
  Color get accent => const Color(0xFFD4937A);
  @override
  Color get accentWarm => const Color(0xFF9E7B8A);
  @override
  Color get surface => _isDark ? const Color(0xFF33282D) : const Color(0xFFF5EBF0);
  @override
  Color get surfaceVariant =>
      _isDark ? const Color(0xFF4A3B42) : const Color(0xFFD9C5CF);
  @override
  Color get textPrimary =>
      _isDark ? const Color(0xFFF5EBF0) : const Color(0xFF2A2024);
  @override
  Color get textSecondary =>
      _isDark ? const Color(0xFFD9C5CF) : const Color(0xFF9E8E95);
  @override
  Color get textOnDark => const Color(0xFFF5EBF0);
  @override
  Color get textOnLight => const Color(0xFF2A2024);
  @override
  Color get error => const Color(0xFFD46B7A);
  @override
  Color get success => const Color(0xFF7ABF9E);

  @override
  Color get glassColor =>
      _isDark ? const Color(0x33000000) : const Color(0x33FFFFFF);
  @override
  Color get glassBorder =>
      _isDark ? const Color(0x1AFFFFFF) : const Color(0x1AFFFFFF);
  @override
  double get glassOpacity => _isDark ? 0.22 : 0.18;
  @override
  double get glassBlur => 22.0;

  @override
  Color get bevelHighlight =>
      _isDark ? const Color(0x20FFFFFF) : const Color(0x32FFFFFF);
  @override
  Color get bevelShadow =>
      _isDark ? const Color(0x40000000) : const Color(0x1E000000);
  @override
  double get bevelIntensity => 1.0;

  @override
  List<String> get backgroundAssets => const [
        'lib/images/backgrounds/13.jpg',
        'lib/images/backgrounds/14.jpg',
        'lib/images/backgrounds/15.jpg',
      ];

  @override
  LinearGradient get overlayGradient => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          primaryDark.withValues(alpha: 0.0),
          primaryDark.withValues(alpha: 0.75),
        ],
      );

  @override
  LinearGradient get cardGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryDark.withValues(alpha: 0.3),
          primaryDark.withValues(alpha: 0.1),
        ],
      );

  @override
  MirageThemeData toDark() => ChampagneRoseTheme(isDark: true);
  @override
  MirageThemeData toLight() => ChampagneRoseTheme(isDark: false);
}
