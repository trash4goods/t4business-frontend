import 'barcode_update_upload_file.dart';

class BarcodeUploadModel {
  final String? name;
  final String? code;
  final String? brand;
  final String? ecoGrade;
  final double? co2Packaging;
  final String? mainMaterial;
  final String? instructions;
  final String? trashType;
  final String? deleteFile;
  final List<BarcodeUpdateUploadFileModel>? uploadFiles;

  BarcodeUploadModel({
    required this.name,
    required this.code,
    required this.brand,
    required this.ecoGrade,
    required this.co2Packaging,
    required this.mainMaterial,
    required this.instructions,
    required this.trashType,
    required this.deleteFile,
    required this.uploadFiles,
  });

  factory BarcodeUploadModel.fromJson(Map<String, dynamic> json) =>
      BarcodeUploadModel(
        name: json['name'] as String?,
        code: json['code'] as String?,
        brand: json['brand'] as String?,
        ecoGrade: json['eco_grade'] as String?,
        co2Packaging: json['co2_packaging'] as double?,
        mainMaterial: json['main_material'] as String?,
        instructions: json['instructions'] as String?,
        trashType: json['trash_type'] as String?,
        deleteFile: json['delete_file'] as String?,
        uploadFiles:
            json['upload_files'] != null
                ? List<BarcodeUpdateUploadFileModel>.from(
                  json['upload_files'].map(
                    (x) => BarcodeUpdateUploadFileModel.fromJson(x),
                  ),
                )
                : null,
      );

  Map<String, dynamic> toJson() => {
    if (name != null) 'name': name,
    if (code != null) 'code': code,
    if (brand != null) 'brand': brand,
    if (ecoGrade != null) 'eco_grade': ecoGrade,
    if (co2Packaging != null) 'co2_packaging': co2Packaging,
    if (mainMaterial != null) 'main_material': mainMaterial,
    if (instructions != null) 'instructions': instructions,
    if (trashType != null) 'trash_type': trashType,
    if (deleteFile != null) 'delete_file': deleteFile,
    if (uploadFiles != null)
      'upload_files': uploadFiles?.map((x) => x.toJson()).toList(),
  };
}
