import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mirage_by_aurues/core/network/connection_status_service.dart';

/// Dio interceptor that reports every successful response and every
/// connectivity error to [ConnectionStatusService].
///
/// This means the online/offline indicator stays in sync with *actual*
/// API communication rather than a separate timer-only ping.
class ConnectionStatusInterceptor extends Interceptor {
  final ConnectionStatusService _statusService;

  ConnectionStatusInterceptor(this._statusService);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Any response (including 4xx) means the server is reachable.
    _statusService.reportSuccess();
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Only connectivity-type errors indicate "offline".
    // 4xx / 5xx responses still mean the server was reachable.
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        debugPrint('[ConnectionInterceptor] Connectivity failure: ${err.type}');
        _statusService.reportFailure();
        break;
      default:
        // badResponse, cancel, unknown — don't change online status
        if (err.response != null) {
          // Server responded, we're online even if it's 500
          _statusService.reportSuccess();
        }
        break;
    }
    handler.next(err);
  }
}
