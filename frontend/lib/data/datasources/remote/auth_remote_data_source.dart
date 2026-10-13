import 'package:dio/dio.dart';
import 'package:mirage_by_aurues/core/error/exceptions.dart';
import 'package:mirage_by_aurues/core/network/api_client.dart';
import 'package:mirage_by_aurues/core/network/api_endpoints.dart';
import 'package:mirage_by_aurues/data/models/user_model.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource(this._apiClient);

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Login failed',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiEndpoints.register,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Registration failed',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.dio.post(ApiEndpoints.logout);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Logout failed',
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.dio.get(ApiEndpoints.user);
      // Backend returns { user: {...} }
      final respData = response.data;
      Map<String, dynamic> userData;
      if (respData is Map && respData.containsKey('user')) {
        userData = respData['user'] as Map<String, dynamic>;
      } else if (respData is Map && respData.containsKey('data')) {
        userData = respData['data'] as Map<String, dynamic>;
      } else {
        userData = respData as Map<String, dynamic>;
      }
      return UserModel.fromJson(userData);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException();
      }
      throw ServerException(
        e.response?.data?['message'] ?? 'Failed to get user',
        statusCode: e.response?.statusCode,
      );
    }
  }
}
