// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_full_roles.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileFullRolesModelAdapter
    extends TypeAdapter<UserProfileFullRolesModel> {
  @override
  final int typeId = 2;

  @override
  UserProfileFullRolesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfileFullRolesModel(
      departmentId: fields[0] as int?,
      name: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfileFullRolesModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.departmentId)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileFullRolesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
