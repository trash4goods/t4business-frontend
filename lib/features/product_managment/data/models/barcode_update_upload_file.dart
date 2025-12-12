class BarcodeUpdateUploadFileModel {
  final String name;
  final String base64;

  BarcodeUpdateUploadFileModel({required this.name, required this.base64});

  factory BarcodeUpdateUploadFileModel.fromJson(Map<String, dynamic> json) => BarcodeUpdateUploadFileModel(
    name: json['name'] as String,
    base64: json['base64'] as String,
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'base64': base64,
  };
}