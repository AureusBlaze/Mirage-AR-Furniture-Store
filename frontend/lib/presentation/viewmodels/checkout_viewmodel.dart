import 'package:flutter/material.dart';
import 'package:mirage_by_aurues/domain/entities/cart_item.dart';
import 'package:mirage_by_aurues/domain/entities/order.dart';
import 'package:mirage_by_aurues/domain/repositories/order_repository.dart';
import 'package:mirage_by_aurues/domain/repositories/cart_repository.dart';

class CheckoutViewModel extends ChangeNotifier {
  final OrderRepository _orderRepository;
  final CartRepository _cartRepository;

  CheckoutViewModel(this._orderRepository, this._cartRepository);

  bool _isLoading = false;
  bool _orderPlaced = false;
  Order? _lastOrder;
  String? _error;

  bool get isLoading => _isLoading;
  bool get orderPlaced => _orderPlaced;
  Order? get lastOrder => _lastOrder;
  String? get error => _error;

  /// Place an order with individual address fields.
  ///
  /// The backend will create an Address record, attach it to the user,
  /// and create the order with the given items.
  Future<bool> placeOrder({
    required String addressLine,
    required String city,
    required String country,
    required String postalCode,
    String? notes,
    required List<CartItem> items,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final orderItems = items
        .map((item) => {
              'product_id': item.productId,
              'quantity': item.quantity,
            })
        .toList();

    final result = await _orderRepository.placeOrder(
      addressLine: addressLine,
      city: city,
      country: country,
      postalCode: postalCode,
      notes: notes,
      items: orderItems,
    );

    _isLoading = false;
    return result.fold(
      (failure) {
        _error = failure.message;
        notifyListeners();
        return false;
      },
      (order) {
        _lastOrder = order;
        _orderPlaced = true;
        _cartRepository.clearCart();
        notifyListeners();
        return true;
      },
    );
  }

  void reset() {
    _orderPlaced = false;
    _lastOrder = null;
    _error = null;
    notifyListeners();
  }
}
