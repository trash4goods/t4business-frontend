import 'package:hive_flutter/hive_flutter.dart';

import 'barcode_result_file.dart';

part 'barcode_result.g.dart';

@HiveType(typeId: 13)
class BarcodeResultModel {
  @HiveField(0)
  final String? brand;
  @HiveField(1)
  final double? co2Packaging;
  @HiveField(2)
  final String? code;
  @HiveField(3)
  final String? ecoGrade;
  @HiveField(4)
  final List<BarcodeResultFileModel>? files;
  @HiveField(5)
  int? id;
  @HiveField(6)
  final String? instructions;
  @HiveField(7)
  final String? mainMaterial;
  @HiveField(8)
  String? name;
  @HiveField(9)
  final String? trashType;

  BarcodeResultModel({
    this.brand,
    this.co2Packaging,
    this.code,
    this.ecoGrade,
    this.files,
    this.id,
    this.instructions,
    this.mainMaterial,
    this.name,
    this.trashType,
  });

  factory BarcodeResultModel.fromJson(Map<String, dynamic> json) =>
      BarcodeResultModel(
        brand: json['brand'] as String?,
        co2Packaging: json['co2_packaging'] as double?,
        code: json['code'] as String?,
        ecoGrade: json['eco_grade'] as String?,
        files:
            json['files'] != null
                ? List<BarcodeResultFileModel>.from(
                  json['files'].map((x) => BarcodeResultFileModel.fromJson(x)),
                )
                : null,
        id: json['id'] as int?,
        instructions: json['instructions'] as String?,
        mainMaterial: json['main_material'] as String?,
        name: json['name'] as String?,
        trashType: json['trash_type'] as String?,
      );

  Map<String, dynamic> toJson() => {
    if (brand != null) 'brand': brand,
    if (co2Packaging != null) 'co2_packaging': co2Packaging,
    if (code != null) 'code': code,
    if (ecoGrade != null) 'eco_grade': ecoGrade,
    if (files != null) 'files': files?.map((x) => x.toJson()).toList(),
    if (id != null) 'id': id,
    if (instructions != null) 'instructions': instructions,
    if (mainMaterial != null) 'main_material': mainMaterial,
    if (name != null) 'name': name,
    if (trashType != null) 'trash_type': trashType,
  };

  // UI Compatibility: Image categorization based on ImageDisplayHelper rules
  String? get headerImage {
    if (files == null || files!.isEmpty) return null;
    return files!.first.url;
  }

  List<String> get carouselImages {
    if (files == null || files!.length <= 2) return [];
    // Return middle images (excluding first and last)
    return files!
        .sublist(1, files!.length - 1)
        .map((file) => file.url ?? '')
        .where((url) => url.isNotEmpty)
        .toList();
  }

  String? get productDetailsImage {
    if (files == null || files!.length < 2) return null;
    return files!.last.url;
  }

  // Backward compatibility aliases
  List<BarcodeResultFileModel> get uploadFiles => files ?? [];
}
