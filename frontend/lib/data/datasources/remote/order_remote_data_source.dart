import 'package:dio/dio.dart';
import 'package:mirage_by_aurues/core/error/exceptions.dart';
import 'package:mirage_by_aurues/core/network/api_client.dart';
import 'package:mirage_by_aurues/core/network/api_endpoints.dart';
import 'package:mirage_by_aurues/data/models/order_model.dart';

class OrderRemoteDataSource {
  final ApiClient _apiClient;

  OrderRemoteDataSource(this._apiClient);

  /// Place a new order with address fields.
  ///
  /// The backend creates an Address record from these fields,
  /// attaches it to the user, and creates the order.
  Future<OrderModel> placeOrder({
    required String addressLine,
    required String city,
    required String country,
    required String postalCode,
    String? notes,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.orders,
        data: {
          'address_line': addressLine,
          'city': city,
          'country': country,
          'postal_code': postalCode,
          if (notes != null && notes.isNotEmpty) 'notes': notes,
          'items': items,
        },
      );
      final data = response.data is Map && response.data.containsKey('data')
          ? response.data['data']
          : response.data;
      return OrderModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to place order',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<List<OrderModel>> getOrders() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.orders);
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
          .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to load orders',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<OrderModel> getOrder(int id) async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.order(id));
      final data = response.data is Map && response.data.containsKey('data')
          ? response.data['data']
          : response.data;
      return OrderModel.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to load order',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
