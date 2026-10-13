import 'package:flutter/material.dart';
import 'package:mirage_by_aurues/domain/entities/product.dart';
import 'package:mirage_by_aurues/domain/repositories/product_repository.dart';

class ArListViewModel extends ChangeNotifier {
  final ProductRepository _productRepository;

  ArListViewModel(this._productRepository);

  List<Product> _products = [];
  bool _isLoading = false;
  String? _error;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadArProducts() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _productRepository.getArProducts();
    result.fold(
      (failure) => _error = failure.message,
      (products) => _products = products,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadArProducts();
  }
}
