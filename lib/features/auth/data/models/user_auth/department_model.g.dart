// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DepartmentModelAdapter extends TypeAdapter<DepartmentModel> {
  @override
  final int typeId = 7;

  @override
  DepartmentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DepartmentModel(
      departmentType: fields[0] as String?,
      departmentUrl: fields[1] as String?,
      description: fields[2] as String?,
      domain: fields[3] as String?,
      files: (fields[4] as List?)?.cast<DepartmentFileModel>(),
      id: fields[5] as int?,
      name: fields[6] as String?,
      status: fields[7] as String?,
      t4bTier: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DepartmentModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.departmentType)
      ..writeByte(1)
      ..write(obj.departmentUrl)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.domain)
      ..writeByte(4)
      ..write(obj.files)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.name)
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.t4bTier);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DepartmentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
