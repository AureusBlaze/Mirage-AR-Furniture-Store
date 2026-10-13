import 'package:dartz/dartz.dart';
import 'package:mirage_by_aurues/core/error/failures.dart';
import 'package:mirage_by_aurues/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts({
    int page = 1,
    int perPage = 20,
    String? search,
    int? categoryId,
  });

  Future<Either<Failure, Product>> getProduct(int id);

  Future<Either<Failure, List<Product>>> getArProducts();

  Future<Either<Failure, List<Product>>> searchProducts(String query);
}
