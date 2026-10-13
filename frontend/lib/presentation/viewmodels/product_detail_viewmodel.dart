import 'package:flutter/material.dart';
import 'package:mirage_by_aurues/domain/entities/product.dart';
import 'package:mirage_by_aurues/domain/repositories/product_repository.dart';

class ProductDetailViewModel extends ChangeNotifier {
  final ProductRepository _productRepository;

  ProductDetailViewModel(this._productRepository);

  Product? _product;
  bool _isLoading = false;
  String? _error;
  int _quantity = 1;

  Product? get product => _product;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get quantity => _quantity;

  Future<void> loadProduct(int id) async {
    _isLoading = true;
    _error = null;
    _quantity = 1;
    notifyListeners();

    final result = await _productRepository.getProduct(id);
    result.fold(
      (failure) => _error = failure.message,
      (product) => _product = product,
    );

    _isLoading = false;
    notifyListeners();
  }

  void incrementQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }
}
