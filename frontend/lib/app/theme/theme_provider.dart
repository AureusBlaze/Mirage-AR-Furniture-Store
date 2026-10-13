import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'themes/mirage_theme_data.dart';
import 'themes/old_money_theme.dart';
import 'themes/midnight_theme.dart';
import 'themes/warm_ivory_theme.dart';
import 'themes/forest_manor_theme.dart';
import 'themes/champagne_rose_theme.dart';
import 'themes/slate_obsidian_theme.dart';
import 'mirage_theme.dart';

/// Manages theme state. Exposes the current [MirageThemeData] and
/// the built [ThemeData]. Persists theme selection, dark mode, and
/// background index to SharedPreferences.
class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'mirage_selected_theme';
  static const String _darkModeKey = 'mirage_dark_mode';
  static const String _bgIndexKey = 'mirage_bg_index';

  /// All available themes (light variants by default). Add new themes here.
  final List<MirageThemeData> availableThemes = [
    OldMoneyTheme(),
    MidnightTheme(),
    WarmIvoryTheme(),
    ForestManorTheme(),
    ChampagneRoseTheme(),
    SlateObsidianTheme(),
  ];

  late MirageThemeData _currentTheme;
  late ThemeData _themeData;
  bool _isDarkMode = false;
  int _currentBackgroundIndex = 0;

  ThemeProvider() {
    _currentTheme = availableThemes.first;
    _themeData = MirageTheme.fromMirageTheme(_currentTheme);
    _loadPersistedSettings();
  }

  MirageThemeData get currentTheme => _currentTheme;
  ThemeData get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;
  int get currentBackgroundIndex => _currentBackgroundIndex;

  /// The currently active background asset path.
  String get currentBackgroundAsset {
    final assets = _currentTheme.backgroundAssets;
    final index = _currentBackgroundIndex.clamp(0, assets.length - 1);
    return assets[index];
  }

  /// Switch to a theme by its [id].
  Future<void> setTheme(String themeId) async {
    final baseTheme = availableThemes.firstWhere(
      (t) => t.id == themeId,
      orElse: () => availableThemes.first,
    );
    _currentBackgroundIndex = 0;
    _applyTheme(baseTheme);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeId);
    await prefs.setInt(_bgIndexKey, 0);
  }

  /// Toggle dark/light mode.
  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    _rebuildCurrentTheme();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, _isDarkMode);
  }

  /// Set dark mode explicitly.
  Future<void> setDarkMode(bool isDark) async {
    if (_isDarkMode == isDark) return;
    _isDarkMode = isDark;
    _rebuildCurrentTheme();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, _isDarkMode);
  }

  /// Cycle to the next background image within the current theme.
  Future<void> cycleBackground() async {
    final assets = _currentTheme.backgroundAssets;
    _currentBackgroundIndex = (_currentBackgroundIndex + 1) % assets.length;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bgIndexKey, _currentBackgroundIndex);
  }

  /// Set a specific background index.
  Future<void> setBackgroundIndex(int index) async {
    final assets = _currentTheme.backgroundAssets;
    _currentBackgroundIndex = index.clamp(0, assets.length - 1);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bgIndexKey, _currentBackgroundIndex);
  }

  void _applyTheme(MirageThemeData baseTheme) {
    _currentTheme = _isDarkMode ? baseTheme.toDark() : baseTheme.toLight();
    _themeData = MirageTheme.fromMirageTheme(_currentTheme);
    notifyListeners();
  }

  void _rebuildCurrentTheme() {
    // Find the base theme from availableThemes by id
    final baseTheme = availableThemes.firstWhere(
      (t) => t.id == _currentTheme.id,
      orElse: () => availableThemes.first,
    );
    _currentTheme = _isDarkMode ? baseTheme.toDark() : baseTheme.toLight();
    _themeData = MirageTheme.fromMirageTheme(_currentTheme);
    notifyListeners();
  }

  Future<void> _loadPersistedSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
      _currentBackgroundIndex = prefs.getInt(_bgIndexKey) ?? 0;

      final savedId = prefs.getString(_themeKey);
      if (savedId != null) {
        final baseTheme = availableThemes.firstWhere(
          (t) => t.id == savedId,
          orElse: () => availableThemes.first,
        );
        _applyTheme(baseTheme);
      } else if (_isDarkMode) {
        _rebuildCurrentTheme();
      }
    } catch (_) {
      // Use default theme on first launch
    }
  }
}
