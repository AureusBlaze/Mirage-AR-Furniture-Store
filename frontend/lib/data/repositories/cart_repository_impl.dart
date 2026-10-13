import 'package:mirage_by_aurues/domain/entities/cart_item.dart';
import 'package:mirage_by_aurues/domain/repositories/cart_repository.dart';
import 'package:mirage_by_aurues/data/datasources/local/cart_local_data_source.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource _localDataSource;

  CartRepositoryImpl(this._localDataSource);

  @override
  Future<List<CartItem>> getCartItems() async {
    return Future.microtask(() => _localDataSource.getCartItems());
  }

  @override
  Future<void> addItem(CartItem item) async {
    return Future.microtask(() => _localDataSource.addItem(item));
  }

  @override
  Future<void> updateQuantity(int productId, int quantity) async {
    return Future.microtask(() => _localDataSource.updateQuantity(productId, quantity));
  }

  @override
  Future<void> removeItem(int productId) async {
    return Future.microtask(() => _localDataSource.removeItem(productId));
  }

  @override
  Future<void> clearCart() async {
    return Future.microtask(() => _localDataSource.clearCart());
  }
}
