import 'package:cloud_firestore/cloud_firestore.dart';

class CsvTemplateModel {
  final bool? isActive;
  final String? fileName;
  final DateTime? createdAt;
  final DateTime? lastModifiedAt;
  final String? storagePath;

  CsvTemplateModel({
    this.isActive,
    this.fileName,
    this.createdAt,
    this.lastModifiedAt,
    this.storagePath,
  });

  factory CsvTemplateModel.fromJson(Map<String, dynamic> json) =>
      CsvTemplateModel(
        isActive: json['is_active'] as bool?,
        fileName: json['file_name'] as String?,
        createdAt: json['created_at'] != null 
            ? _parseDateTime(json['created_at'])
            : null,
        lastModifiedAt: json['last_modified_at'] != null
            ? _parseDateTime(json['last_modified_at'])
            : null,
        storagePath: json['storage_path'] as String?,
      );

  static DateTime _parseDateTime(dynamic value) {
    if (value is String) {
      return DateTime.parse(value);
    } else if (value is Timestamp) {
      return value.toDate();
    } else {
      throw ArgumentError('Invalid date format: $value');
    }
  }

  Map<String, dynamic> toJson() => {
        if (isActive != null) 'is_active': isActive,
        if (fileName != null) 'file_name': fileName,
        if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
        if (lastModifiedAt != null) 'last_modified_at': lastModifiedAt!.toIso8601String(),
        if (storagePath != null) 'storage_path': storagePath,
      };

  CsvTemplateModel copyWith({
    bool? isActive,
    String? fileName,
    DateTime? createdAt,
    DateTime? lastModifiedAt,
    String? storagePath,
  }) {
    return CsvTemplateModel(
      isActive: isActive ?? this.isActive,
      fileName: fileName ?? this.fileName,
      createdAt: createdAt ?? this.createdAt,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
      storagePath: storagePath ?? this.storagePath,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CsvTemplateModel &&
        other.isActive == isActive &&
        other.fileName == fileName &&
        other.createdAt == createdAt &&
        other.lastModifiedAt == lastModifiedAt &&
        other.storagePath == storagePath;
  }

  @override
  int get hashCode {
    return isActive.hashCode ^
        fileName.hashCode ^
        createdAt.hashCode ^
        lastModifiedAt.hashCode ^
        storagePath.hashCode;
  }

  @override
  String toString() {
    return 'CsvTemplateModel(isActive: $isActive, fileName: $fileName, createdAt: $createdAt, lastModifiedAt: $lastModifiedAt, storagePath: $storagePath)';
  }
}