import 'package:dio/dio.dart';
import 'package:mirage_by_aurues/core/error/exceptions.dart';
import 'package:mirage_by_aurues/core/network/api_client.dart';
import 'package:mirage_by_aurues/core/network/api_endpoints.dart';
import 'package:mirage_by_aurues/data/models/category_model.dart';

class CategoryRemoteDataSource {
  final ApiClient _apiClient;

  CategoryRemoteDataSource(this._apiClient);

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.categories);
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
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to load categories',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<CategoryModel> getCategory(int id) async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.category(id));
      final data = response.data is Map && response.data.containsKey('data')
          ? response.data['data']
          : response.data;
      return CategoryModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to load category',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
