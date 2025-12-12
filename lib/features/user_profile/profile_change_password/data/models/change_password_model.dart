class ChangePasswordModel {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordModel({
    required this.oldPassword,
    required this.newPassword,
  });

  factory ChangePasswordModel.fromJson(Map<String, dynamic> json) =>
      ChangePasswordModel(
        oldPassword: json['old_password'] as String,
        newPassword: json['new_password'] as String,
      );

  Map<String, dynamic> toJson() => {
    'old_password': oldPassword,
    'new_password': newPassword,
  };

  ChangePasswordModel copyWith({String? oldPassword, String? newPassword}) =>
      ChangePasswordModel(
        oldPassword: oldPassword ?? this.oldPassword,
        newPassword: newPassword ?? this.newPassword,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChangePasswordModel &&
          runtimeType == other.runtimeType &&
          oldPassword == other.oldPassword &&
          newPassword == other.newPassword;

  @override
  int get hashCode => oldPassword.hashCode ^ newPassword.hashCode;

  @override
  String toString() =>
      'ChangePasswordModel('
      'oldPassword: [HIDDEN], '
      'newPassword: [HIDDEN]'
      ')';
}
