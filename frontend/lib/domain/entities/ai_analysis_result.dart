import 'package:mirage_by_aurues/domain/entities/product.dart';

/// Result of an AI room analysis — suggested products + room description.
class AiAnalysisResult {
  final List<Product> products;
  final String? description;

  const AiAnalysisResult({required this.products, this.description});
}
