import 'package:flutter/material.dart';
import 'package:mirage_by_aurues/core/utils/debouncer.dart';
import 'package:mirage_by_aurues/domain/entities/product.dart';
import 'package:mirage_by_aurues/domain/repositories/product_repository.dart';

class SearchViewModel extends ChangeNotifier {
  final ProductRepository _productRepository;
  final Debouncer _debouncer = Debouncer();

  SearchViewModel(this._productRepository);

  List<Product> _results = [];
  bool _isLoading = false;
  String _query = '';
  String? _error;

  List<Product> get results => _results;
  bool get isLoading => _isLoading;
  String get query => _query;
  String? get error => _error;

  void search(String query) {
    _query = query;
    if (query.isEmpty) {
      _results = [];
      _error = null;
      notifyListeners();
      return;
    }

    _debouncer.run(() => _executeSearch(query));
  }

  Future<void> _executeSearch(String query) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _productRepository.searchProducts(query);
    result.fold(
      (failure) => _error = failure.message,
      (products) => _results = products,
    );

    _isLoading = false;
    notifyListeners();
  }

  void clear() {
    _query = '';
    _results = [];
    _error = null;
    _debouncer.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}
