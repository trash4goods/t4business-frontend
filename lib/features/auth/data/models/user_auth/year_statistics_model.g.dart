// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year_statistics_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class YearStatisticsModelAdapter extends TypeAdapter<YearStatisticsModel> {
  @override
  final int typeId = 6;

  @override
  YearStatisticsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return YearStatisticsModel(
      co2: fields[0] as int?,
      bins: fields[1] as int?,
      events: fields[2] as int?,
      months: (fields[3] as List?)?.cast<MonthStatisticsModel>(),
      podiums: fields[4] as int?,
      prizes: fields[5] as int?,
      products: fields[6] as int?,
      reports: fields[7] as int?,
      scans: fields[8] as int?,
      year: fields[9] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, YearStatisticsModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.co2)
      ..writeByte(1)
      ..write(obj.bins)
      ..writeByte(2)
      ..write(obj.events)
      ..writeByte(3)
      ..write(obj.months)
      ..writeByte(4)
      ..write(obj.podiums)
      ..writeByte(5)
      ..write(obj.prizes)
      ..writeByte(6)
      ..write(obj.products)
      ..writeByte(7)
      ..write(obj.reports)
      ..writeByte(8)
      ..write(obj.scans)
      ..writeByte(9)
      ..write(obj.year);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is YearStatisticsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
