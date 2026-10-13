import 'package:mirage_by_aurues/domain/entities/order.dart';

class OrderModel {
  final int id;
  final String status;
  final double totalAmount;
  final String? shippingAddress;
  final List<OrderItemModel> items;
  final DateTime? createdAt;

  const OrderModel({
    required this.id,
    required this.status,
    required this.totalAmount,
    this.shippingAddress,
    this.items = const [],
    this.createdAt,
  });

  /// Parses the actual Laravel OrderResource JSON payload.
  ///
  /// Key mappings:
  /// - `total_price` (float) → `totalAmount` (also checks `total_amount`, `total`)
  /// - `items[]` → each contains nested `product` object
  /// - `addresses[]` (pivot array) → flatten to single shipping address string
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // ── Parse total ──
    final double total = (json['total_price'] as num?)?.toDouble() ??
        (json['total_amount'] as num?)?.toDouble() ??
        (json['total'] as num?)?.toDouble() ??
        0.0;

    // ── Parse addresses → flatten to single string ──
    String? address;
    final addressesList = json['addresses'] as List?;
    if (addressesList != null && addressesList.isNotEmpty) {
      final addr = addressesList.first as Map<String, dynamic>;
      final parts = <String>[
        if (addr['address_line'] != null) addr['address_line'] as String,
        if (addr['city'] != null) addr['city'] as String,
        if (addr['country'] != null) addr['country'] as String,
        if (addr['postal_code'] != null) addr['postal_code'] as String,
      ];
      address = parts.join(', ');
    }
    address ??= json['shipping_address'] as String?;

    return OrderModel(
      id: json['id'] as int,
      status: json['status'] as String? ?? 'pending',
      totalAmount: total,
      shippingAddress: address,
      items: (json['items'] as List?)
              ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Order toEntity() => Order(
        id: id,
        status: status,
        totalAmount: totalAmount,
        shippingAddress: shippingAddress,
        items: items.map((i) => i.toEntity()).toList(),
        createdAt: createdAt,
      );
}

class OrderItemModel {
  final int productId;
  final String productName;
  final int quantity;
  final double price;
  final double? subtotal;

  const OrderItemModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    this.subtotal,
  });

  /// Parses the actual Laravel OrderItemResource JSON payload.
  ///
  /// Key mappings:
  /// - `product` (nested ProductResource) → extract `product.id` and `product.name`
  /// - `unit_price` → `price`
  /// - `subtotal` → directly parsed
  /// - Falls back to flat `product_id` / `product_name` for compatibility
  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    final productObj = json['product'] as Map<String, dynamic>?;

    return OrderItemModel(
      productId: productObj?['id'] as int? ??
          json['product_id'] as int? ??
          0,
      productName: productObj?['name'] as String? ??
          json['product_name'] as String? ??
          '',
      quantity: json['quantity'] as int? ?? 1,
      price: (json['unit_price'] as num?)?.toDouble() ??
          (json['price'] as num?)?.toDouble() ??
          0.0,
      subtotal: (json['subtotal'] as num?)?.toDouble(),
    );
  }

  OrderItem toEntity() => OrderItem(
        productId: productId,
        productName: productName,
        quantity: quantity,
        price: price,
        subtotal: subtotal,
      );
}
