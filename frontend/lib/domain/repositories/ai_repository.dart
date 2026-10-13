import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:mirage_by_aurues/core/error/failures.dart';
import 'package:mirage_by_aurues/domain/entities/ai_analysis_result.dart';

abstract class AiRepository {
  /// Upload a room photo and get AI analysis (suggestions + description).
  Future<Either<Failure, AiAnalysisResult>> getSuggestions(File image);
}
