import 'package:flutter/material.dart';
import 'mirage_theme_data.dart';

/// "Warm Ivory" aesthetic — creamy whites, soft golds, natural linen warmth.
class WarmIvoryTheme extends MirageThemeData {
  final bool _isDark;
  WarmIvoryTheme({bool isDark = false}) : _isDark = isDark;

  @override
  String get id => 'warm_ivory';
  @override
  String get name => 'Warm Ivory';
  @override
  String get description => 'Creamy whites & soft golds — natural linen warmth';
  @override
  Brightness get brightness => _isDark ? Brightness.dark : Brightness.light;

  @override
  Color get primaryDark => const Color(0xFF2B2520);
  @override
  Color get primaryLight => const Color(0xFFF5F0EA);
  @override
  Color get accent => const Color(0xFFD4A55A);
  @override
  Color get accentWarm => const Color(0xFF8C7A65);
  @override
  Color get surface => _isDark ? const Color(0xFF342E28) : const Color(0xFFF5F0EA);
  @override
  Color get surfaceVariant =>
      _isDark ? const Color(0xFF4A423A) : const Color(0xFFD9CCBB);
  @override
  Color get textPrimary =>
      _isDark ? const Color(0xFFF5F0EA) : const Color(0xFF2B2520);
  @override
  Color get textSecondary =>
      _isDark ? const Color(0xFFD9CCBB) : const Color(0xFF9E9084);
  @override
  Color get textOnDark => const Color(0xFFF5F0EA);
  @override
  Color get textOnLight => const Color(0xFF2B2520);
  @override
  Color get error => const Color(0xFFD4756B);
  @override
  Color get success => const Color(0xFF7DB87D);

  @override
  Color get glassColor =>
      _isDark ? const Color(0x33000000) : const Color(0x33FFFFFF);
  @override
  Color get glassBorder =>
      _isDark ? const Color(0x1AFFFFFF) : const Color(0x1AFFFFFF);
  @override
  double get glassOpacity => _isDark ? 0.25 : 0.2;
  @override
  double get glassBlur => 18.0;

  @override
  Color get bevelHighlight =>
      _isDark ? const Color(0x20FFFFFF) : const Color(0x35FFFFFF);
  @override
  Color get bevelShadow =>
      _isDark ? const Color(0x40000000) : const Color(0x1E000000);
  @override
  double get bevelIntensity => 1.0;

  @override
  List<String> get backgroundAssets => const [
        'lib/images/backgrounds/7.jpg',
        'lib/images/backgrounds/8.jpg',
        'lib/images/backgrounds/9.jpg',
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
  MirageThemeData toDark() => WarmIvoryTheme(isDark: true);
  @override
  MirageThemeData toLight() => WarmIvoryTheme(isDark: false);
}
