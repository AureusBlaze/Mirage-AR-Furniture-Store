import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? role;
  final int? defaultAddressId;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.role,
    this.defaultAddressId,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, email, role, createdAt];
}
