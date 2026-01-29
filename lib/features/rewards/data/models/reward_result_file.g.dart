// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_result_file.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RewardResultFileModelAdapter extends TypeAdapter<RewardResultFileModel> {
  @override
  final int typeId = 22;

  @override
  RewardResultFileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RewardResultFileModel(
      createdBy: fields[0] as RewardResultFileCreatedByModel?,
      fileName: fields[1] as String?,
      id: fields[2] as int?,
      mimeType: fields[3] as String?,
      size: fields[4] as int?,
      url: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RewardResultFileModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.createdBy)
      ..writeByte(1)
      ..write(obj.fileName)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.mimeType)
      ..writeByte(4)
      ..write(obj.size)
      ..writeByte(5)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RewardResultFileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
