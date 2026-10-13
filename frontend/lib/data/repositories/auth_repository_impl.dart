import 'package:dartz/dartz.dart';
import 'package:mirage_by_aurues/core/error/exceptions.dart';
import 'package:mirage_by_aurues/core/error/failures.dart';
import 'package:mirage_by_aurues/core/storage/secure_storage.dart';
import 'package:mirage_by_aurues/domain/entities/user.dart';
import 'package:mirage_by_aurues/domain/repositories/auth_repository.dart';
import 'package:mirage_by_aurues/data/datasources/remote/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorage;

  AuthRepositoryImpl(this._remoteDataSource, this._secureStorage);

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final data = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      // Backend returns { user: {...}, token: "..." }
      final token = data['token'] as String? ?? '';
      await _secureStorage.saveToken(token);

      final userData = data['user'] as Map<String, dynamic>?;
      if (userData != null) {
        final user = _parseUser(userData);
        return Right(user);
      }
      // If no user data in login response, fetch it
      return getCurrentUser();
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final data = await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      // Backend returns { user: {...}, token: "..." }
      final token = data['token'] as String? ?? '';
      await _secureStorage.saveToken(token);

      final userData = data['user'] as Map<String, dynamic>?;
      if (userData != null) {
        final user = _parseUser(userData);
        return Right(user);
      }
      return getCurrentUser();
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _secureStorage.deleteToken();
      return const Right(null);
    } on ServerException catch (e) {
      // Even if server logout fails, clear local token
      await _secureStorage.deleteToken();
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      await _secureStorage.deleteToken();
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final userModel = await _remoteDataSource.getCurrentUser();
      return Right(userModel.toEntity());
    } on UnauthorizedException {
      return const Left(AuthFailure('Session expired'));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() => _secureStorage.hasToken();

  User _parseUser(Map<String, dynamic> json) {
    // Extract default address ID from nested object
    final defaultAddr = json['default_address'] as Map<String, dynamic>?;
    final int? addrId = defaultAddr?['id'] as int? ??
        json['default_address_id'] as int?;

    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String?,
      defaultAddressId: addrId,
    );
  }
}
