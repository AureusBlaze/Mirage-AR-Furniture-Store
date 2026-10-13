import 'package:dartz/dartz.dart';
import 'package:mirage_by_aurues/core/error/failures.dart';
import 'package:mirage_by_aurues/domain/entities/order.dart' as entities;

abstract class OrderRepository {
  Future<Either<Failure, entities.Order>> placeOrder({
    required String addressLine,
    required String city,
    required String country,
    required String postalCode,
    String? notes,
    required List<Map<String, dynamic>> items,
  });

  Future<Either<Failure, List<entities.Order>>> getOrders();
  Future<Either<Failure, entities.Order>> getOrder(int id);
}
