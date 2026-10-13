import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mirage_by_aurues/core/utils/constants.dart';
import 'package:mirage_by_aurues/core/storage/secure_storage.dart';
import 'auth_interceptor.dart';
import 'connection_status_interceptor.dart';
import 'connection_status_service.dart';

/// Configured Dio client for API communication.
class ApiClient {
  late final Dio dio;

  ApiClient({required SecureStorageService secureStorage, String? initialBaseUrl}) {
    dio = Dio(
      BaseOptions(
        baseUrl: initialBaseUrl ?? AppConstants.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(secureStorage),
      // Lightweight request logger — only logs method + URL + status.
      // The previous LogInterceptor with responseBody:true was printing
      // entire JSON payloads synchronously on the UI thread, blocking it.
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('[API] → ${options.method} ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('[API] ← ${response.statusCode} ${response.requestOptions.path}');
          handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('[API] ✖ ${error.type} ${error.requestOptions.path}');
          handler.next(error);
        },
      ),
    ]);
  }

  /// Attach the connection-status interceptor **after** both ApiClient and
  /// ConnectionStatusService have been created (breaks circular dependency).
  void attachStatusInterceptor(ConnectionStatusService statusService) {
    dio.interceptors.add(ConnectionStatusInterceptor(statusService));
  }

  /// Dynamically update the base URL used by all subsequent requests.
  void updateBaseUrl(String newUrl) {
    dio.options.baseUrl = newUrl;
  }
}
