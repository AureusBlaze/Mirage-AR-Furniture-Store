import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mirage_by_aurues/core/error/exceptions.dart';
import 'package:mirage_by_aurues/core/network/api_client.dart';
import 'package:mirage_by_aurues/core/network/api_endpoints.dart';
import 'package:mirage_by_aurues/data/models/product_model.dart';

/// Response container for the AI suggest endpoint.
class AiSuggestResponse {
  final List<ProductModel> products;
  final String? description;

  AiSuggestResponse({required this.products, this.description});
}

class AiRemoteDataSource {
  final ApiClient _apiClient;

  AiRemoteDataSource(this._apiClient);

  /// Upload a room image to the AI endpoint and get product suggestions.
  Future<AiSuggestResponse> getSuggestions(File image) async {
    try {
      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          image.path,
          filename: 'room_analysis.jpg',
        ),
      });

      final response = await _apiClient.dio.post(
        ApiEndpoints.aiSuggest,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          receiveTimeout: const Duration(seconds: 120),
        ),
      );

      dynamic data = response.data;
      if (data is String) {
        try {
          data = jsonDecode(data);
        } catch (_) {}
      }

      debugPrint('[AI] Raw response type: ${data.runtimeType}');
      debugPrint('[AI] Raw response: $data');

      // ─── Extract description ──────────────────────────────────────
      String? description;
      if (data is Map && data.containsKey('description')) {
        description = data['description'] as String?;
      }

      // ─── Extract product suggestions ──────────────────────────────
      List<dynamic> items;

      if (data is Map && data.containsKey('suggestions')) {
        // Backend returns: { "detected_tags": [...], "suggestions": { "data": [...] } }
        final suggestions = data['suggestions'];
        debugPrint('[AI] suggestions type: ${suggestions.runtimeType}');
        if (suggestions is Map && suggestions.containsKey('data')) {
          items = suggestions['data'] as List;
        } else if (suggestions is List) {
          items = suggestions;
        } else {
          items = [];
        }
      } else if (data is Map && data.containsKey('data')) {
        items = data['data'] as List;
      } else if (data is Map && data.containsKey('products')) {
        items = data['products'] as List;
      } else if (data is List) {
        items = data;
      } else {
        debugPrint('[AI] Could not find items in data. Defaulting to empty list.');
        items = [];
      }

      debugPrint('[AI] Parsed ${items.length} product items');
      debugPrint('[AI] Description: ${description ?? 'none'}');

      final products = items
          .map((json) {
            try {
              return ProductModel.fromJson(Map<String, dynamic>.from(json as Map));
            } catch (e, st) {
              debugPrint('[AI] Error parsing product: $e\n$st');
              return null;
            }
          })
          .whereType<ProductModel>()
          .toList();

      return AiSuggestResponse(
        products: products,
        description: description,
      );
    } on DioException catch (e) {
      debugPrint('[AI] DioException: ${e.message}');
      debugPrint('[AI] Response data: ${e.response?.data}');
      throw ServerException(
        e.response?.data?['message'] ?? 'AI analysis failed',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
