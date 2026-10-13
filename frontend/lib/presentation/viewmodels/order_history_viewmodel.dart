import 'package:flutter/material.dart';
import 'package:mirage_by_aurues/domain/entities/order.dart' as entities;
import 'package:mirage_by_aurues/domain/repositories/order_repository.dart';

class OrderHistoryViewModel extends ChangeNotifier {
  final OrderRepository _orderRepository;

  OrderHistoryViewModel(this._orderRepository);

  List<entities.Order> _orders = [];
  bool _isLoading = false;
  String? _error;

  List<entities.Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadOrders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await _orderRepository.getOrders();
    result.fold(
      (failure) => _error = failure.message,
      (orders) => _orders = orders,
    );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadOrders();
  }
}
