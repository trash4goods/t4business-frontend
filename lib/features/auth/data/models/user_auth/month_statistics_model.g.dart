// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'month_statistics_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MonthStatisticsModelAdapter extends TypeAdapter<MonthStatisticsModel> {
  @override
  final int typeId = 8;

  @override
  MonthStatisticsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MonthStatisticsModel(
      actions: fields[0] as int?,
      month: fields[1] as int?,
      metal: (fields[2] as List?)?.cast<int>(),
      plastic: (fields[3] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, MonthStatisticsModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.actions)
      ..writeByte(1)
      ..write(obj.month)
      ..writeByte(2)
      ..write(obj.metal)
      ..writeByte(3)
      ..write(obj.plastic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MonthStatisticsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
