// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_result_file_createdby.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RewardResultFileCreatedByModelAdapter
    extends TypeAdapter<RewardResultFileCreatedByModel> {
  @override
  final int typeId = 23;

  @override
  RewardResultFileCreatedByModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RewardResultFileCreatedByModel(
      id: fields[0] as int?,
      name: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RewardResultFileCreatedByModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RewardResultFileCreatedByModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
