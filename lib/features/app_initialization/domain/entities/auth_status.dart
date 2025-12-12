// features/app_initialization/domain/entities/auth_status_entity.dart

class AuthStatusEntity {
  final bool isAuthenticated;
  final String? token;
  final DateTime? lastChecked;

  const AuthStatusEntity({
    required this.isAuthenticated,
    this.token,
    this.lastChecked,
  });

  factory AuthStatusEntity.unauthenticated() => const AuthStatusEntity(
    isAuthenticated: false,
    token: null,
    lastChecked: null,
  );

  factory AuthStatusEntity.authenticated({
    required String token,
    DateTime? lastChecked,
  }) => AuthStatusEntity(
    isAuthenticated: true,
    token: token,
    lastChecked: lastChecked ?? DateTime.now(),
  );
}
