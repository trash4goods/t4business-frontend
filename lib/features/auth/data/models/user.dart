// features/auth/domain/entities/user_entity.dart
import '../../domain/entities/user.dart';

class UserModel {
  final String email;
  final String? token;

  const UserModel({required this.email, this.token});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    email: json['email'] as String,
    token: json['token'] as String?,
  );

  Map<String, dynamic> toJson() => {'email': email, 'token': token};

  UserEntity toEntity() => UserEntity(email: email, token: token);
}
