// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rules.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RulesModelAdapter extends TypeAdapter<RulesModel> {
  @override
  final int typeId = 14;

  @override
  RulesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RulesModel(
      pagination: fields[0] as RulesPaginationModel?,
      result: (fields[1] as List?)?.cast<RulesResultModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, RulesModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.pagination)
      ..writeByte(1)
      ..write(obj.result);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RulesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
