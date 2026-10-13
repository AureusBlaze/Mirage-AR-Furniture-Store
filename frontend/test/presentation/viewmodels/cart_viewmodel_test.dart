import 'package:flutter_test/flutter_test.dart';
import 'package:mirage_by_aurues/domain/entities/cart_item.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/cart_viewmodel.dart';
import 'package:mirage_by_aurues/data/repositories/cart_repository_impl.dart';
import 'package:mirage_by_aurues/data/datasources/local/cart_local_data_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late CartViewModel viewModel;
  late CartRepositoryImpl cartRepository;
  late CartLocalDataSource cartLocalDataSource;

  setUp(() {
    cartLocalDataSource = CartLocalDataSource();
    cartRepository = CartRepositoryImpl(cartLocalDataSource);
    viewModel = CartViewModel(cartRepository);
  });

  group('CartViewModel Regression Tests', () {
    test('Handles empty cart properly', () async {
      await viewModel.loadCart();
      expect(viewModel.items.isEmpty, true);
      expect(viewModel.totalAmount, 0.0);
      expect(viewModel.itemCount, 0);
    });

    test('Handles a single item safely', () async {
      final item = const CartItem(
        productId: 1,
        name: 'Luxurious Sofa',
        price: 999.0,
        quantity: 1,
      );
      
      await viewModel.addToCart(item);

      expect(viewModel.items.length, 1);
      expect(viewModel.totalAmount, 999.0);
      expect(viewModel.itemCount, 1);
    });

    test('Handles 10,000 items in O(1) getter time without blocking Main Thread', () async {
      // Simulate bulk database load, bypassing UI event loop delays
      for (int i = 0; i < 10000; i++) {
        cartLocalDataSource.addItem(CartItem(
          productId: i,
          name: 'Item $i',
          price: 10.0,
          quantity: 2,
        ));
      }

      final stopwatch = Stopwatch()..start();
      
      // Load will trigger array pull and _recalculateTotals exactly once
      await viewModel.loadCart();
      stopwatch.stop();

      // Verifying state properties
      expect(viewModel.items.length, 10000);
      expect(viewModel.itemCount, 20000); // 10000 items * 2 quantity
      expect(viewModel.totalAmount, 200000.0); // 10000 * 20.0
      
      // Ensure the calculation process (even with 10k items) doesn't hang UI
      expect(stopwatch.elapsedMilliseconds < 500, true);
    });
  });
}
