import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:mirage_by_aurues/core/error/exceptions.dart';
import 'package:mirage_by_aurues/core/error/failures.dart';
import 'package:mirage_by_aurues/domain/entities/ai_analysis_result.dart';
import 'package:mirage_by_aurues/domain/repositories/ai_repository.dart';
import 'package:mirage_by_aurues/data/datasources/remote/ai_remote_data_source.dart';

class AiRepositoryImpl implements AiRepository {
  final AiRemoteDataSource _remoteDataSource;

  AiRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, AiAnalysisResult>> getSuggestions(File image) async {
    try {
      final response = await _remoteDataSource.getSuggestions(image);
      return Right(AiAnalysisResult(
        products: response.products.map((m) => m.toEntity()).toList(),
        description: response.description,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
