import 'package:hive_flutter/hive_flutter.dart';

import 'department_model.dart';
part 'user_profile_partners_departments.g.dart';

// UserPartnersDepartmentModel - Main model for user partners departments
@HiveType(typeId: 5)
class UserPartnersDepartmentModel {
  @HiveField(0)
  final DepartmentModel? department;
  @HiveField(1)
  final dynamic partner; // Can be null or any type

  UserPartnersDepartmentModel({
    this.department,
    this.partner,
  });

  factory UserPartnersDepartmentModel.fromJson(Map<String, dynamic> json) {
    return UserPartnersDepartmentModel(
      department: json['department'] != null
          ? DepartmentModel.fromJson(json['department'] as Map<String, dynamic>)
          : null,
      partner: json['partner'],
    );
  }

  Map<String, dynamic> toJson() => {
    'department': department?.toJson(),
    'partner': partner,
  };
}
