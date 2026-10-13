import 'package:mirage_by_aurues/domain/entities/cart_item.dart';

/// Cart is local-only (Hive), no Either/Failure needed.
abstract class CartRepository {
  Future<List<CartItem>> getCartItems();
  Future<void> addItem(CartItem item);
  Future<void> updateQuantity(int productId, int quantity);
  Future<void> removeItem(int productId);
  Future<void> clearCart();
}
