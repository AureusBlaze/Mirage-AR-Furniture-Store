import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final List<String> images;
  final int categoryId;
  final String? categoryName;
  final bool hasArModel;
  final String? arModelUrl;
  final bool inStock;
  final int? stockQuantity;
  final DateTime? createdAt;
  // Additional fields from backend
  final String? slug;
  final double? weight;
  final String? dimensions;
  final String? material;
  final String? vendorName;
  final List<String> tags;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    this.images = const [],
    required this.categoryId,
    this.categoryName,
    this.hasArModel = false,
    this.arModelUrl,
    this.inStock = true,
    this.stockQuantity,
    this.createdAt,
    this.slug,
    this.weight,
    this.dimensions,
    this.material,
    this.vendorName,
    this.tags = const [],
  });

  @override
  List<Object?> get props => [id, name, price, categoryId, hasArModel];
}
