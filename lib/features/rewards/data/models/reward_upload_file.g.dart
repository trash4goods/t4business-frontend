// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_upload_file.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RewardUploadFileModelAdapter extends TypeAdapter<RewardUploadFileModel> {
  @override
  final int typeId = 24;

  @override
  RewardUploadFileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RewardUploadFileModel(
      name: fields[0] as String?,
      base64: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RewardUploadFileModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.base64);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RewardUploadFileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
