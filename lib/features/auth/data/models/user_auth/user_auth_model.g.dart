// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_auth_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAuthModelAdapter extends TypeAdapter<UserAuthModel> {
  @override
  final int typeId = 0;

  @override
  UserAuthModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserAuthModel(
      accessToken: fields[0] as String?,
      expiresIn: fields[1] as String?,
      profile: fields[2] as UserProfileModel?,
      refreshToken: fields[3] as String?,
      tokenType: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserAuthModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.accessToken)
      ..writeByte(1)
      ..write(obj.expiresIn)
      ..writeByte(2)
      ..write(obj.profile)
      ..writeByte(3)
      ..write(obj.refreshToken)
      ..writeByte(4)
      ..write(obj.tokenType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAuthModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
