import 'package:flutter/material.dart';
import 'mirage_theme_data.dart';

/// "Forest Manor" aesthetic — deep greens, aged wood tones, estate library feel.
class ForestManorTheme extends MirageThemeData {
  final bool _isDark;
  ForestManorTheme({bool isDark = false}) : _isDark = isDark;

  @override
  String get id => 'forest_manor';
  @override
  String get name => 'Forest Manor';
  @override
  String get description => 'Deep greens & aged wood — estate library feel';
  @override
  Brightness get brightness => _isDark ? Brightness.dark : Brightness.light;

  @override
  Color get primaryDark => const Color(0xFF1A2418);
  @override
  Color get primaryLight => const Color(0xFFE5EAE0);
  @override
  Color get accent => const Color(0xFF8DB580);
  @override
  Color get accentWarm => const Color(0xFF6B7A5E);
  @override
  Color get surface => _isDark ? const Color(0xFF222E20) : const Color(0xFFE5EAE0);
  @override
  Color get surfaceVariant =>
      _isDark ? const Color(0xFF374433) : const Color(0xFFC2CDB8);
  @override
  Color get textPrimary =>
      _isDark ? const Color(0xFFE5EAE0) : const Color(0xFF1A2418);
  @override
  Color get textSecondary =>
      _isDark ? const Color(0xFFC2CDB8) : const Color(0xFF7E8B74);
  @override
  Color get textOnDark => const Color(0xFFE5EAE0);
  @override
  Color get textOnLight => const Color(0xFF1A2418);
  @override
  Color get error => const Color(0xFFCC6B6B);
  @override
  Color get success => const Color(0xFF6BBF6B);

  @override
  Color get glassColor =>
      _isDark ? const Color(0x33000000) : const Color(0x33FFFFFF);
  @override
  Color get glassBorder =>
      _isDark ? const Color(0x1AFFFFFF) : const Color(0x1AFFFFFF);
  @override
  double get glassOpacity => _isDark ? 0.22 : 0.18;
  @override
  double get glassBlur => 20.0;

  @override
  Color get bevelHighlight =>
      _isDark ? const Color(0x1EFFFFFF) : const Color(0x30FFFFFF);
  @override
  Color get bevelShadow =>
      _isDark ? const Color(0x3E000000) : const Color(0x1C000000);
  @override
  double get bevelIntensity => 1.0;

  @override
  List<String> get backgroundAssets => const [
        'lib/images/backgrounds/10.jpg',
        'lib/images/backgrounds/11.jpg',
        'lib/images/backgrounds/12.jpg',
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
  MirageThemeData toDark() => ForestManorTheme(isDark: true);
  @override
  MirageThemeData toLight() => ForestManorTheme(isDark: false);
}
