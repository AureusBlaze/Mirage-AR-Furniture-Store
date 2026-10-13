/// Application-wide constants.
/// Edit the [baseUrl] to match your local Laravel server IP.
class AppConstants {
  AppConstants._();

  // ─── API ─────────────────────────────────────────────────────────
  /// Change this to your local Laravel API IP address.
  static const String baseUrl = 'http://192.168.0.133:8000/api';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // ─── Storage Keys ────────────────────────────────────────────────
  static const String authTokenKey = 'auth_token';
  static const String userKey = 'user_data';

  // ─── UI ──────────────────────────────────────────────────────────
  static const Duration splashDuration = Duration(milliseconds: 2500);
  static const Duration searchDebounce = Duration(milliseconds: 300);
  static const int catalogPageSize = 20;
}
