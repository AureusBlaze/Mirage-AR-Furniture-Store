import 'package:dartz/dartz.dart';
import 'package:mirage_by_aurues/core/error/failures.dart';
import 'package:mirage_by_aurues/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<Category>>> getCategories();
  Future<Either<Failure, Category>> getCategory(int id);
}
