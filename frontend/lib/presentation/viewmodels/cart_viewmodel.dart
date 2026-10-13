import 'package:flutter/widgets.dart';
import 'package:mirage_by_aurues/domain/entities/cart_item.dart';
import 'package:mirage_by_aurues/domain/repositories/cart_repository.dart';

class CartViewModel extends ChangeNotifier {
  final CartRepository _cartRepository;

  CartViewModel(this._cartRepository);

  List<CartItem> _items = [];
  bool _isLoading = false;
  bool _isBusy = false; // guards against concurrent add/remove operations
  String? _error;
  bool _disposed = false;
  bool _pendingNotify = false;

  int _itemCount = 0;
  double _totalAmount = 0.0;

  List<CartItem> get items => _items;
  bool get isLoading => _isLoading;
  bool get isBusy => _isBusy;
  String? get error => _error;
  int get itemCount => _itemCount;
  double get totalAmount => _totalAmount;

  void _recalculateTotals() {
    _itemCount = _items.fold(0, (sum, item) => sum + item.quantity);
    _totalAmount = _items.fold(0.0, (sum, item) => sum + item.total);
  }

  /// Schedules a single notification per frame.
  ///
  /// Multiple calls between frames are coalesced into one notification.
  /// This prevents the cascading rebuild problem where notifyListeners()
  /// during synchronous cart mutations triggers expensive cross-route
  /// rebuilds (e.g. the MirageTopBar Consumer in the offscreen AppShell)
  /// while the rendering pipeline is still compositing the current frame.
  void _scheduleNotify() {
    if (_disposed || _pendingNotify) return;
    _pendingNotify = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pendingNotify = false;
      if (!_disposed) notifyListeners();
    });
    // Ensure the framework actually schedules a frame so the callback fires
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  Future<void> loadCart() async {
    _isLoading = true;
    _scheduleNotify();

    try {
      _items = await _cartRepository.getCartItems();
      _recalculateTotals();
      _error = null;
    } catch (e, stack) {
      debugPrint('[CartViewModel] loadCart error: $e\n$stack');
      _error = 'Failed to load cart: $e';
    } finally {
      _isLoading = false;
      _scheduleNotify();
    }
  }

  /// Adds an item to the cart.
  ///
  /// Returns `true` on success, `false` on failure. The caller can use
  /// this to decide whether to show a success or error snackbar.
  Future<bool> addToCart(CartItem item) async {
    // Guard: prevent double-tap / concurrent mutations
    if (_isBusy) {
      debugPrint('[CartViewModel] addToCart skipped — already busy');
      return false;
    }

    _isBusy = true;
    _error = null;

    try {
      debugPrint('[CartViewModel] Adding to cart: '
          '${item.name} (id=${item.productId}, qty=${item.quantity})');

      await _cartRepository.addItem(item);
      _items = await _cartRepository.getCartItems();
      _recalculateTotals();

      debugPrint('[CartViewModel] Cart now has ${_items.length} unique items, '
          '$itemCount total units');

      _isBusy = false;
      _scheduleNotify();

      // Yield to the event loop so the post-frame callback fires
      // before we return to the caller. This ensures the UI has a
      // chance to process the rebuild before the snackbar is shown.
      await Future<void>.delayed(const Duration(milliseconds: 50));

      return true;
    } catch (e, stack) {
      debugPrint('[CartViewModel] ❌ addToCart FAILED: $e\n$stack');
      _error = 'Could not add item to cart: $e';
      _isBusy = false;
      _scheduleNotify();
      return false;
    }
  }

  Future<void> updateQuantity(int productId, int quantity) async {
    if (_isBusy) return;
    _isBusy = true;

    try {
      await _cartRepository.updateQuantity(productId, quantity);
      _items = await _cartRepository.getCartItems();
      _recalculateTotals();
    } catch (e, stack) {
      debugPrint('[CartViewModel] updateQuantity error: $e\n$stack');
      _error = 'Failed to update quantity: $e';
    } finally {
      _isBusy = false;
      _scheduleNotify();
    }
  }

  Future<void> removeItem(int productId) async {
    if (_isBusy) return;
    _isBusy = true;

    try {
      await _cartRepository.removeItem(productId);
      _items = await _cartRepository.getCartItems();
      _recalculateTotals();
    } catch (e, stack) {
      debugPrint('[CartViewModel] removeItem error: $e\n$stack');
      _error = 'Failed to remove item: $e';
    } finally {
      _isBusy = false;
      _scheduleNotify();
    }
  }

  Future<void> clearCart() async {
    if (_isBusy) return;
    _isBusy = true;

    try {
      await _cartRepository.clearCart();
      _items = [];
      _recalculateTotals();
    } catch (e, stack) {
      debugPrint('[CartViewModel] clearCart error: $e\n$stack');
      _error = 'Failed to clear cart: $e';
    } finally {
      _isBusy = false;
      _scheduleNotify();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
