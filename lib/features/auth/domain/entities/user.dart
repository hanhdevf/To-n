import 'package:equatable/equatable.dart';

/// User entity representing authenticated user
class User extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final String? photoUrl;
  final DateTime? createdAt;

  const User({
    required this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, displayName, photoUrl, createdAt];

  @override
  String toString() => 'User(id: $id, email: $email, name: $displayName)';
}
