// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_partners_departments.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserPartnersDepartmentModelAdapter
    extends TypeAdapter<UserPartnersDepartmentModel> {
  @override
  final int typeId = 5;

  @override
  UserPartnersDepartmentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserPartnersDepartmentModel(
      department: fields[0] as DepartmentModel?,
      partner: fields[1] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, UserPartnersDepartmentModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.department)
      ..writeByte(1)
      ..write(obj.partner);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserPartnersDepartmentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
