import 'package:flutter/material.dart';
import 'mirage_theme_data.dart';

/// "Slate Obsidian" aesthetic — charcoal greys, steely blues, industrial luxury.
class SlateObsidianTheme extends MirageThemeData {
  final bool _isDark;
  SlateObsidianTheme({bool isDark = false}) : _isDark = isDark;

  @override
  String get id => 'slate_obsidian';
  @override
  String get name => 'Slate Obsidian';
  @override
  String get description => 'Charcoal greys & steely blues — industrial luxury';
  @override
  Brightness get brightness => _isDark ? Brightness.dark : Brightness.light;

  @override
  Color get primaryDark => const Color(0xFF18191D);
  @override
  Color get primaryLight => const Color(0xFFE3E4E8);
  @override
  Color get accent => const Color(0xFF8FA4B8);
  @override
  Color get accentWarm => const Color(0xFF5C6878);
  @override
  Color get surface => _isDark ? const Color(0xFF21222A) : const Color(0xFFE3E4E8);
  @override
  Color get surfaceVariant =>
      _isDark ? const Color(0xFF33353F) : const Color(0xFFBABCC5);
  @override
  Color get textPrimary =>
      _isDark ? const Color(0xFFE3E4E8) : const Color(0xFF18191D);
  @override
  Color get textSecondary =>
      _isDark ? const Color(0xFFBABCC5) : const Color(0xFF7D7F88);
  @override
  Color get textOnDark => const Color(0xFFE3E4E8);
  @override
  Color get textOnLight => const Color(0xFF18191D);
  @override
  Color get error => const Color(0xFFD06B6B);
  @override
  Color get success => const Color(0xFF6BB8A0);

  @override
  Color get glassColor =>
      _isDark ? const Color(0x33000000) : const Color(0x33FFFFFF);
  @override
  Color get glassBorder =>
      _isDark ? const Color(0x1AFFFFFF) : const Color(0x1AFFFFFF);
  @override
  double get glassOpacity => _isDark ? 0.22 : 0.16;
  @override
  double get glassBlur => 22.0;

  @override
  Color get bevelHighlight =>
      _isDark ? const Color(0x1EFFFFFF) : const Color(0x30FFFFFF);
  @override
  Color get bevelShadow =>
      _isDark ? const Color(0x44000000) : const Color(0x20000000);
  @override
  double get bevelIntensity => 1.0;

  @override
  List<String> get backgroundAssets => const [
        'lib/images/backgrounds/16.jpeg',
        'lib/images/backgrounds/17.jpg',
        'lib/images/backgrounds/18.jpg',
      ];

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
  LinearGradient get cardGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryDark.withValues(alpha: 0.3),
          primaryDark.withValues(alpha: 0.1),
        ],
      );

  @override
  MirageThemeData toDark() => SlateObsidianTheme(isDark: true);
  @override
  MirageThemeData toLight() => SlateObsidianTheme(isDark: false);
}
