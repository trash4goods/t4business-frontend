// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rules_pagination.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RulesPaginationModelAdapter extends TypeAdapter<RulesPaginationModel> {
  @override
  final int typeId = 15;

  @override
  RulesPaginationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RulesPaginationModel(
      count: fields[0] as int?,
      hasNext: fields[1] as bool?,
      page: fields[2] as int?,
      perPage: fields[3] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, RulesPaginationModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.count)
      ..writeByte(1)
      ..write(obj.hasNext)
      ..writeByte(2)
      ..write(obj.page)
      ..writeByte(3)
      ..write(obj.perPage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RulesPaginationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
