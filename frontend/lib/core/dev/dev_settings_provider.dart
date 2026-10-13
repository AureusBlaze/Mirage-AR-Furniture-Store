import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mirage_by_aurues/core/network/api_client.dart';
import 'package:mirage_by_aurues/core/utils/constants.dart';

/// Manages the developer-overridable API base URL.
///
/// Reads/writes a custom URL to [SharedPreferences] and live-updates
/// the [ApiClient]'s Dio base URL so the change takes effect immediately
/// without an app restart.
class DevSettingsProvider extends ChangeNotifier {
  static const String _urlKey = 'dev_override_base_url';

  final ApiClient _apiClient;

  String _activeBaseUrl = AppConstants.baseUrl;
  bool _isOverridden = false;

  DevSettingsProvider(this._apiClient) {
    _loadPersistedUrl();
  }

  // ─── Getters ───────────────────────────────────────────────────────

  /// The URL currently used by Dio.
  String get activeBaseUrl => _activeBaseUrl;

  /// Whether the URL has been overridden by the developer.
  bool get isOverridden => _isOverridden;

  /// The compile-time default URL from [AppConstants].
  String get defaultBaseUrl => AppConstants.baseUrl;

  // ─── Actions ───────────────────────────────────────────────────────

  /// Save a new base URL, update Dio immediately, and persist to disk.
  Future<void> setBaseUrl(String url) async {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return;

    _activeBaseUrl = trimmed;
    _isOverridden = trimmed != AppConstants.baseUrl;
    _apiClient.updateBaseUrl(trimmed);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_urlKey, trimmed);
  }

  /// Reset to the compile-time default, clear the persisted override.
  Future<void> resetBaseUrl() async {
    _activeBaseUrl = AppConstants.baseUrl;
    _isOverridden = false;
    _apiClient.updateBaseUrl(AppConstants.baseUrl);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_urlKey);
  }

  // ─── Internal ──────────────────────────────────────────────────────

  Future<void> _loadPersistedUrl() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(_urlKey);
      if (saved != null && saved.isNotEmpty) {
        _activeBaseUrl = saved;
        _isOverridden = saved != AppConstants.baseUrl;
        _apiClient.updateBaseUrl(saved);
        notifyListeners();
      }
    } catch (_) {
      // First launch — no override stored, use default.
    }
  }
}
