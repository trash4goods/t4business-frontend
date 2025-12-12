class BarcodeResultFileCreatedByModel {
  final int? id;
  final String? name;

  BarcodeResultFileCreatedByModel({this.id, this.name});

  factory BarcodeResultFileCreatedByModel.fromJson(Map<String, dynamic> json) =>
      BarcodeResultFileCreatedByModel(
        id: json['id'] as int?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
