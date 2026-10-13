import 'package:mirage_by_aurues/domain/entities/cart_item.dart';

/// Local cart data source using in-memory storage.
/// (A Hive-based persistent version can be swapped in later.)
class CartLocalDataSource {
  final List<CartItem> _items = [];

  List<CartItem> getCartItems() => List.unmodifiable(_items);

  void addItem(CartItem item) {
    final index = _items.indexWhere((i) => i.productId == item.productId);
    if (index >= 0) {
      _items[index] = _items[index].copyWith(
        quantity: _items[index].quantity + item.quantity,
      );
    } else {
      _items.add(item);
    }
  }

  void updateQuantity(int productId, int quantity) {
    final index = _items.indexWhere((i) => i.productId == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index] = _items[index].copyWith(quantity: quantity);
      }
    }
  }

  void removeItem(int productId) {
    _items.removeWhere((i) => i.productId == productId);
  }

  void clearCart() {
    _items.clear();
  }
}
