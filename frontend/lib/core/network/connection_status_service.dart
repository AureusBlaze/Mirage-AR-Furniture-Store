import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:mirage_by_aurues/core/network/api_client.dart';
import 'package:mirage_by_aurues/core/network/api_endpoints.dart';

/// Centralized connectivity service that determines online/offline status
/// based on **actual backend reachability**, not just local Wi-Fi state.
///
/// Exposes:
///  - [isOnline] getter for immediate polling.
///  - [statusStream] for reactive UI bindings.
///  - [reportSuccess] / [reportFailure] for Dio interceptor integration.
///  - [checkNow] for manual pings.
class ConnectionStatusService extends ChangeNotifier {
  final ApiClient _apiClient;

  bool _isOnline = false;
  bool _isChecking = true;
  Timer? _pollTimer;

  /// Tracks when the last successful response was received.
  DateTime? _lastSuccessAt;

  /// If we got a successful API response within this window,
  /// skip redundant health-check pings.
  static const _freshnessWindow = Duration(seconds: 30);

  /// Polling interval for the background health-check.
  static const _pollInterval = Duration(seconds: 10);

  bool get isOnline => _isOnline;
  bool get isChecking => _isChecking;

  /// A broadcast stream that emits `true` (online) or `false` (offline)
  /// every time the status changes.
  final StreamController<bool> _statusController =
      StreamController<bool>.broadcast();
  Stream<bool> get statusStream => _statusController.stream;

  ConnectionStatusService(this._apiClient) {
    _startPolling();
  }

  // ─── Public API ──────────────────────────────────────────────────

  /// Called by an interceptor or repository after a *successful* API response.
  void reportSuccess() {
    _lastSuccessAt = DateTime.now();
    // Only notify if status actually changed to avoid redundant rebuilds.
    // Previously this called _setOnline(true) on EVERY API response,
    // which triggered notifyListeners() on every single network call.
    if (!_isOnline) {
      _setOnline(true);
    }
  }

  /// Called by an interceptor or repository after a *connectivity* failure
  /// (timeout, socket error, etc.). Does NOT fire for 4xx/5xx — those still
  /// mean the server is reachable.
  void reportFailure() {
    _setOnline(false);
  }

  /// Manually trigger a health-check right now.
  Future<void> checkNow() => _ping();

  // ─── Internal ────────────────────────────────────────────────────

  void _startPolling() {
    // Immediate first check
    _ping();
    _pollTimer = Timer.periodic(_pollInterval, (_) => _ping());
  }

  Future<void> _ping() async {
    // Only skip the ping if we are ALREADY online and had a recent
    // successful response.  When `_isOnline` is false the ping must
    // always fire so the indicator recovers promptly.
    if (_isOnline &&
        _lastSuccessAt != null &&
        DateTime.now().difference(_lastSuccessAt!) < _freshnessWindow) {
      if (_isChecking) {
        _isChecking = false;
        notifyListeners();
      }
      return;
    }

    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.categories,
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
          // Skip auth for health-check
          extra: {'skipAuth': true},
        ),
      );

      final ok = response.statusCode != null &&
          response.statusCode! >= 200 &&
          response.statusCode! < 500;

      if (ok) _lastSuccessAt = DateTime.now();
      _setOnline(ok);
    } on DioException catch (e) {
      debugPrint('[ConnectionStatus] Ping failed: ${e.type} – ${e.message}');
      _setOnline(false);
    } catch (e) {
      debugPrint('[ConnectionStatus] Unexpected ping error: $e');
      _setOnline(false);
    } finally {
      if (_isChecking) {
        _isChecking = false;
        notifyListeners();
      }
    }
  }

  void _setOnline(bool value) {
    if (_isOnline != value || _isChecking) {
      _isOnline = value;
      _isChecking = false;
      _statusController.add(value);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _statusController.close();
    super.dispose();
  }
}
