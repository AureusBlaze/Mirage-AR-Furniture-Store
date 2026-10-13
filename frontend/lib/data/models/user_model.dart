import 'package:mirage_by_aurues/domain/entities/user.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? role;
  final int? defaultAddressId;
  final DateTime? createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.defaultAddressId,
    this.createdAt,
  });

  /// Parses the actual Laravel UserResource JSON payload.
  ///
  /// Key mappings:
  /// - `role` (enum string) parsed directly
  /// - `default_address` (nested object) → extract `id` for `defaultAddressId`
  /// - No `avatar` field exists in backend — removed
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Extract default address ID from nested object or direct field
    final defaultAddr = json['default_address'] as Map<String, dynamic>?;
    final int? addrId = defaultAddr?['id'] as int? ??
        json['default_address_id'] as int?;

    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String?,
      defaultAddressId: addrId,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  User toEntity() => User(
        id: id,
        name: name,
        email: email,
        role: role,
        defaultAddressId: defaultAddressId,
        createdAt: createdAt,
      );
}
