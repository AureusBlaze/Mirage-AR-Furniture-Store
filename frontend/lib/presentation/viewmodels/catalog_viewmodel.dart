import 'package:flutter/material.dart';
import 'package:mirage_by_aurues/domain/entities/category.dart';
import 'package:mirage_by_aurues/domain/entities/product.dart';
import 'package:mirage_by_aurues/domain/repositories/category_repository.dart';
import 'package:mirage_by_aurues/domain/repositories/product_repository.dart';

class CatalogViewModel extends ChangeNotifier {
  final ProductRepository _productRepository;
  final CategoryRepository _categoryRepository;

  CatalogViewModel(this._productRepository, this._categoryRepository);

  // ─── Product State ──────────────────────────────────────────────
  List<Product> _products = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _error;
  int _currentPage = 1;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get error => _error;

  // ─── Category / Filter State ────────────────────────────────────
  List<Category> _categories = [];
  int? _selectedCategoryId;
  String? _selectedCategoryName;
  bool _isCategoriesLoading = false;

  List<Category> get categories => _categories;
  int? get selectedCategoryId => _selectedCategoryId;
  String? get selectedCategoryName => _selectedCategoryName;
  bool get hasActiveFilter => _selectedCategoryId != null;
  bool get isCategoriesLoading => _isCategoriesLoading;

  // ─── Load Categories (for the filter sheet) ─────────────────────
  Future<void> loadCategories() async {
    if (_categories.isNotEmpty) return; // already loaded
    _isCategoriesLoading = true;
    notifyListeners();

    final result = await _categoryRepository.getCategories();
    result.fold(
      (failure) => debugPrint('[CatalogVM] Failed to load categories: ${failure.message}'),
      (categories) => _categories = categories,
    );

    _isCategoriesLoading = false;
    notifyListeners();
  }

  // ─── Set / Clear Category Filter ────────────────────────────────
  void setCategory(int? id, [String? name]) {
    _selectedCategoryId = id;
    _selectedCategoryName = name;
    notifyListeners();
    loadProducts();
  }

  void clearFilter() {
    _selectedCategoryId = null;
    _selectedCategoryName = null;
    notifyListeners();
    loadProducts();
  }

  // ─── Load Products (respects stored filter) ─────────────────────
  Future<void> loadProducts({int? categoryId}) async {
    _isLoading = true;
    _error = null;
    _currentPage = 1;
    notifyListeners();

    // Use explicit param OR the stored filter
    final effectiveId = categoryId ?? _selectedCategoryId;

    final result = await _productRepository.getProducts(
      page: _currentPage,
      categoryId: effectiveId,
    );
    result.fold(
      (failure) => _error = failure.message,
      (products) {
        _products = products;
        _hasMore = products.length >= 20;
      },
    );

    _isLoading = false;
    notifyListeners();
  }

  // ─── Pagination (uses stored filter automatically) ──────────────
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    _currentPage++;
    final result = await _productRepository.getProducts(
      page: _currentPage,
      categoryId: _selectedCategoryId,
    );
    result.fold(
      (failure) {
        _currentPage--;
        _error = failure.message;
      },
      (products) {
        _products = [..._products, ...products];
        _hasMore = products.length >= 20;
      },
    );

    _isLoadingMore = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadProducts();
  }
}
