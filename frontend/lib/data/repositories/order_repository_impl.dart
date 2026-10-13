import 'package:dartz/dartz.dart';
import 'package:mirage_by_aurues/core/error/exceptions.dart';
import 'package:mirage_by_aurues/core/error/failures.dart';
import 'package:mirage_by_aurues/domain/entities/order.dart' as entities;
import 'package:mirage_by_aurues/domain/repositories/order_repository.dart';
import 'package:mirage_by_aurues/data/datasources/remote/order_remote_data_source.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _remoteDataSource;

  OrderRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, entities.Order>> placeOrder({
    required String addressLine,
    required String city,
    required String country,
    required String postalCode,
    String? notes,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final model = await _remoteDataSource.placeOrder(
        addressLine: addressLine,
        city: city,
        country: country,
        postalCode: postalCode,
        notes: notes,
        items: items,
      );
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<entities.Order>>> getOrders() async {
    try {
      final models = await _remoteDataSource.getOrders();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, entities.Order>> getOrder(int id) async {
    try {
      final model = await _remoteDataSource.getOrder(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
