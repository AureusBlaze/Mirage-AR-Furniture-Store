import 'package:flutter/material.dart';
import 'package:mirage_by_aurues/domain/entities/category.dart';
import 'package:mirage_by_aurues/domain/repositories/category_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final CategoryRepository _categoryRepository;

  HomeViewModel(this._categoryRepository);

  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadCategories() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _categoryRepository.getCategories();
    result.fold(
      (failure) => _error = failure.message,
      (categories) => _categories = categories,
    );

    _isLoading = false;
    notifyListeners();
  }
}
