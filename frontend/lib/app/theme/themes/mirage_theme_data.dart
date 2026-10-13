import 'package:flutter/material.dart';

/// Abstract definition for a Mirage theme.
/// Each theme provides its own colors, background, glass, and bevel properties.
/// Themes support light/dark mode via [brightness] and multiple backgrounds
/// that can be cycled via [backgroundAssets].
abstract class MirageThemeData {
  String get id;
  String get name;
  String get description;

  /// Whether this theme instance represents a light or dark variant.
  Brightness get brightness;

  // ─── Core Colors ─────────────────────────────────────────────────
  Color get primaryDark;
  Color get primaryLight;
  Color get accent;
  Color get accentWarm;
  Color get surface;
  Color get surfaceVariant;
  Color get textPrimary;
  Color get textSecondary;
  Color get textOnDark;
  Color get textOnLight;
  Color get error;
  Color get success;

  // ─── Glass Properties ────────────────────────────────────────────
  Color get glassColor;
  Color get glassBorder;
  double get glassOpacity;
  double get glassBlur;

  // ─── Bevel Properties ────────────────────────────────────────────
  Color get bevelHighlight;
  Color get bevelShadow;
  double get bevelIntensity;

  // ─── Backgrounds ─────────────────────────────────────────────────
  /// List of background asset paths for this theme (3 per theme).
  List<String> get backgroundAssets;

  /// Default background index (usually 0).
  int get defaultBackgroundIndex => 0;

  /// Convenience — returns the first background.
  String get backgroundAsset => backgroundAssets[defaultBackgroundIndex];

  // ─── Gradients ───────────────────────────────────────────────────
  LinearGradient get overlayGradient;
  LinearGradient get cardGradient;

  /// Returns the dark-mode variant of this theme.
  MirageThemeData toDark();

  /// Returns the light-mode variant of this theme.
  MirageThemeData toLight();
}
