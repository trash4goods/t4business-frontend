// features/auth/domain/entities/user_entity.dart
class UserEntity {
  final String email;
  final String? token;

  const UserEntity({required this.email, this.token});

  Map<String, dynamic> toJson() => {'email': email, 'token': token};
}
