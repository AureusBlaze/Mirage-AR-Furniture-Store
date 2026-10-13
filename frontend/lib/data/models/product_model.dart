import 'package:mirage_by_aurues/domain/entities/product.dart';

class ProductModel {
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
  final String? slug;
  final double? weight;
  final String? dimensions;
  final String? material;
  final String? vendorName;
  final List<String> tags;

  const ProductModel({
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

  /// Parses the actual Laravel ProductResource JSON payload.
  ///
  /// Key mappings:
  /// - `stock` (int) → `inStock` (bool, stock > 0) + `stockQuantity`
  /// - `category` (nested object) → `categoryId` + `categoryName`
  /// - `media` (array with pivot) → `imageUrl` (primary) + `images` (all image URLs)
  /// - `ar_model` (nested object or null) → `hasArModel` + `arModelUrl`
  /// - `vendor` (nested object) → `vendorName`
  /// - `tags` (array of objects) → tag name strings
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // ── Parse media array → extract image URLs ──
    String? primaryImageUrl;
    final List<String> imageUrls = [];

    final mediaList = json['media'] as List?;
    if (mediaList != null) {
      for (final m in mediaList) {
        if (m is Map<String, dynamic>) {
          final url = m['url'] as String?;
          final type = m['type'] as String? ?? 'image';
          if (url != null && url.isNotEmpty && type == 'image') {
            imageUrls.add(url);
            // Check pivot is_primary flag — SQLite returns 0/1 integers
            final isPrimary = m['is_primary'] == true || m['is_primary'] == 1;
            if (isPrimary) {
              primaryImageUrl = url;
            }
          }
        }
      }
    }
    // Fallback: if no primary image was flagged, use the first image
    primaryImageUrl ??= imageUrls.isNotEmpty ? imageUrls.first : null;

    // Also support direct `image_url` / `image` fallback for simplified payloads
    primaryImageUrl ??= json['image_url'] as String? ?? json['image'] as String?;

    // ── Parse AR model ──
    final arModelData = json['ar_model'] as Map<String, dynamic>?;
    final bool hasAr = arModelData != null;
    final String? arUrl = arModelData?['file_url'] as String?;

    // Fallback for simplified payloads — handle int/bool ambiguity
    final bool hasArFallback = json['has_ar_model'] == true || json['has_ar_model'] == 1 || hasAr;
    final String? arUrlFallback = json['ar_model_url'] as String? ?? arUrl;

    // ── Parse category (nested object or flat IDs) ──
    final categoryObj = json['category'] as Map<String, dynamic>?;
    final int catId = categoryObj?['id'] as int? ??
        json['category_id'] as int? ??
        0;
    final String? catName = categoryObj?['name'] as String? ??
        json['category_name'] as String?;

    // ── Parse stock — handle int/bool ambiguity for in_stock ──
    final int stock = json['stock'] as int? ?? 0;
    final bool isInStock = json['in_stock'] == true || json['in_stock'] == 1 || (json['in_stock'] == null && stock > 0);

    // ── Parse vendor ──
    final vendorObj = json['vendor'] as Map<String, dynamic>?;
    final String? vName = vendorObj?['name'] as String?;

    // ── Parse tags ──
    final tagsList = json['tags'] as List?;
    final List<String> tagNames = tagsList
            ?.map((t) => (t is Map ? t['name'] as String? ?? '' : t.toString()))
            .where((s) => s.isNotEmpty)
            .toList() ??
        [];

    return ProductModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String?,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: primaryImageUrl,
      images: imageUrls,
      categoryId: catId,
      categoryName: catName,
      hasArModel: hasArFallback,
      arModelUrl: arUrlFallback,
      inStock: isInStock,
      stockQuantity: stock > 0 ? stock : json['stock_quantity'] as int?,
      weight: (json['weight'] as num?)?.toDouble(),
      dimensions: json['dimensions'] as String?,
      material: json['material'] as String?,
      vendorName: vName,
      tags: tagNames,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Product toEntity() => Product(
        id: id,
        name: name,
        description: description,
        price: price,
        imageUrl: imageUrl,
        images: images,
        categoryId: categoryId,
        categoryName: categoryName,
        hasArModel: hasArModel,
        arModelUrl: arModelUrl,
        inStock: inStock,
        stockQuantity: stockQuantity,
        createdAt: createdAt,
        slug: slug,
        weight: weight,
        dimensions: dimensions,
        material: material,
        vendorName: vendorName,
        tags: tags,
      );
}
