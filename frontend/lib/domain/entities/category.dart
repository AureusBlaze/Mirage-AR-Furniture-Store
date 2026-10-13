import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int id;
  final String name;
  final String? description;
  final String? imageUrl;
  final int productCount;
  final String? slug;
  final int? parentId;
  final List<Category> children;

  const Category({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.productCount = 0,
    this.slug,
    this.parentId,
    this.children = const [],
  });

  @override
  List<Object?> get props => [id, name];
}
