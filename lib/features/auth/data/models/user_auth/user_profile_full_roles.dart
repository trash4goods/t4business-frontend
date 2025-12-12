import 'package:hive_flutter/hive_flutter.dart';

part 'user_profile_full_roles.g.dart';

@HiveType(typeId: 2)
class UserProfileFullRolesModel {
  @HiveField(0)
  int? departmentId;
  @HiveField(1)
  String? name;

  UserProfileFullRolesModel({this.departmentId, this.name});

  factory UserProfileFullRolesModel.fromJson(Map<String, dynamic> json) {
    return UserProfileFullRolesModel(
      departmentId: json['department_id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'department_id': departmentId,
    'name': name,
  };
}
