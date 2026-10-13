import 'package:equatable/equatable.dart';

class Order extends Equatable {
  final int id;
  final String status;
  final double totalAmount;
  final String? shippingAddress;
  final List<OrderItem> items;
  final DateTime? createdAt;

  const Order({
    required this.id,
    required this.status,
    required this.totalAmount,
    this.shippingAddress,
    this.items = const [],
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, status, totalAmount];
}

class OrderItem extends Equatable {
  final int productId;
  final String productName;
  final int quantity;
  final double price;
  final double? subtotal;

  const OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    this.subtotal,
  });

  @override
  List<Object?> get props => [productId, quantity, price];
}
