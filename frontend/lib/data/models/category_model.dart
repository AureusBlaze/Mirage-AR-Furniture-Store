import 'package:mirage_by_aurues/domain/entities/category.dart';

class CategoryModel {
  final int id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int productCount;
  final String? slug;
  final int? parentId;
  final List<CategoryModel> children;

  const CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.productCount = 0,
    this.slug,
    this.parentId,
    this.children = const [],
  });

  /// Parses the actual Laravel CategoryResource JSON payload.
  ///
  /// Key mappings:
  /// - `products_count` (from withCount) → `productCount`
  /// - `children` (nested CategoryResource array) → recursive parse
  /// - `slug`, `parent_id` parsed directly
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    // Parse children recursively
    final childrenList = json['children'] as List?;
    final List<CategoryModel> parsedChildren = childrenList
            ?.map((c) =>
                CategoryModel.fromJson(c as Map<String, dynamic>))
            .toList() ??
        [];

    return CategoryModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String? ?? json['image'] as String?,
      productCount: json['products_count'] as int? ??
          json['product_count'] as int? ??
          0,
      slug: json['slug'] as String?,
      parentId: json['parent_id'] as int?,
      children: parsedChildren,
    );
  }

  Category toEntity() => Category(
        id: id,
        name: name,
        description: description,
        imageUrl: imageUrl,
        productCount: productCount,
        slug: slug,
        parentId: parentId,
        children: children.map((c) => c.toEntity()).toList(),
      );
}
