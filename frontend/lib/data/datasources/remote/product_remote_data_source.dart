import 'package:dio/dio.dart';
import 'package:mirage_by_aurues/core/error/exceptions.dart';
import 'package:mirage_by_aurues/core/network/api_client.dart';
import 'package:mirage_by_aurues/core/network/api_endpoints.dart';
import 'package:mirage_by_aurues/data/models/product_model.dart';

class ProductRemoteDataSource {
  final ApiClient _apiClient;

  ProductRemoteDataSource(this._apiClient);

  Future<List<ProductModel>> getProducts({
    int page = 1,
    int perPage = 20,
    String? search,
    int? categoryId,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'per_page': perPage,
      };
      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (categoryId != null) {
        queryParams['category_id'] = categoryId;
      }

      final response = await _apiClient.dio.get(
        ApiEndpoints.products,
        queryParameters: queryParams,
      );

      final data = response.data;
      List<dynamic> items;
      if (data is Map && data.containsKey('data')) {
        items = data['data'] as List;
      } else if (data is List) {
        items = data;
      } else {
        items = [];
      }

      return items
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to load products',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<ProductModel> getProduct(int id) async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.product(id));
      final data = response.data is Map && response.data.containsKey('data')
          ? response.data['data']
          : response.data;
      return ProductModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to load product',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<List<ProductModel>> getArProducts() async {
    try {
      final response = await _apiClient.dio.get(
        ApiEndpoints.products,
        queryParameters: {'has_ar': true},
      );
      final data = response.data;
      List<dynamic> items;
      if (data is Map && data.containsKey('data')) {
        items = data['data'] as List;
      } else if (data is List) {
        items = data;
      } else {
        items = [];
      }
      return items
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to load AR products',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
