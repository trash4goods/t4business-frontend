// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileModelAdapter extends TypeAdapter<UserProfileModel> {
  @override
  final int typeId = 1;

  @override
  UserProfileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfileModel(
      credits1: fields[0] as int?,
      credits2: fields[1] as int?,
      email: fields[2] as String?,
      emailVerifiedAt: fields[3] as String?,
      expoToken: fields[4] as String?,
      fcmToken: fields[5] as String?,
      firstName: fields[6] as String?,
      fullRoles: (fields[7] as List?)?.cast<UserProfileFullRolesModel>(),
      googleToken: fields[8] as String?,
      id: fields[9] as int?,
      insertedAt: fields[10] as String?,
      isAdmin: fields[11] as bool?,
      lastName: fields[12] as String?,
      name: fields[13] as String?,
      phoneIndicative: fields[14] as String?,
      phoneNumber: fields[15] as String?,
      preferences: fields[16] as UserPreferencesModel?,
      roles: (fields[17] as List?)?.cast<String>(),
      statistics: fields[18] as UserStatisticsModel?,
      status: fields[19] as String?,
      userPartnersDepartments:
          (fields[20] as List?)?.cast<UserPartnersDepartmentModel>(),
      username: fields[21] as String?,
      utcOffsetH: fields[22] as int?,
      utcOffsetM: fields[23] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfileModel obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.credits1)
      ..writeByte(1)
      ..write(obj.credits2)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.emailVerifiedAt)
      ..writeByte(4)
      ..write(obj.expoToken)
      ..writeByte(5)
      ..write(obj.fcmToken)
      ..writeByte(6)
      ..write(obj.firstName)
      ..writeByte(7)
      ..write(obj.fullRoles)
      ..writeByte(8)
      ..write(obj.googleToken)
      ..writeByte(9)
      ..write(obj.id)
      ..writeByte(10)
      ..write(obj.insertedAt)
      ..writeByte(11)
      ..write(obj.isAdmin)
      ..writeByte(12)
      ..write(obj.lastName)
      ..writeByte(13)
      ..write(obj.name)
      ..writeByte(14)
      ..write(obj.phoneIndicative)
      ..writeByte(15)
      ..write(obj.phoneNumber)
      ..writeByte(16)
      ..write(obj.preferences)
      ..writeByte(17)
      ..write(obj.roles)
      ..writeByte(18)
      ..write(obj.statistics)
      ..writeByte(19)
      ..write(obj.status)
      ..writeByte(20)
      ..write(obj.userPartnersDepartments)
      ..writeByte(21)
      ..write(obj.username)
      ..writeByte(22)
      ..write(obj.utcOffsetH)
      ..writeByte(23)
      ..write(obj.utcOffsetM);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
