import 'package:equatable/equatable.dart';

class CartItem extends Equatable {
  final int productId;
  final String name;
  final double price;
  final String? imageUrl;
  final int quantity;

  const CartItem({
    required this.productId,
    required this.name,
    required this.price,
    this.imageUrl,
    this.quantity = 1,
  });

  double get total => price * quantity;

  CartItem copyWith({int? quantity}) => CartItem(
        productId: productId,
        name: name,
        price: price,
        imageUrl: imageUrl,
        quantity: quantity ?? this.quantity,
      );

  @override
  List<Object?> get props => [productId, quantity];
}
