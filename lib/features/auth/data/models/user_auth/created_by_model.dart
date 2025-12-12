// CreatedByModel - User who created the file
import 'package:hive_flutter/hive_flutter.dart';

part 'created_by_model.g.dart';

@HiveType(typeId: 10)
class CreatedByModel {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? name;

  CreatedByModel({
    this.id,
    this.name,
  });

  factory CreatedByModel.fromJson(Map<String, dynamic> json) {
    return CreatedByModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}