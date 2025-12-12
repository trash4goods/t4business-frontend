// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_statistics_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserStatisticsModelAdapter extends TypeAdapter<UserStatisticsModel> {
  @override
  final int typeId = 4;

  @override
  UserStatisticsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserStatisticsModel(
      totalActions: fields[0] as int?,
      totalBins: fields[1] as int?,
      totalCO2: fields[2] as int?,
      totalEvents: fields[3] as int?,
      totalPodiums: fields[4] as int?,
      totalPrizes: fields[5] as int?,
      totalProducts: fields[6] as int?,
      totalReports: fields[7] as int?,
      totalScans: fields[8] as int?,
      years: (fields[9] as List?)?.cast<YearStatisticsModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserStatisticsModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.totalActions)
      ..writeByte(1)
      ..write(obj.totalBins)
      ..writeByte(2)
      ..write(obj.totalCO2)
      ..writeByte(3)
      ..write(obj.totalEvents)
      ..writeByte(4)
      ..write(obj.totalPodiums)
      ..writeByte(5)
      ..write(obj.totalPrizes)
      ..writeByte(6)
      ..write(obj.totalProducts)
      ..writeByte(7)
      ..write(obj.totalReports)
      ..writeByte(8)
      ..write(obj.totalScans)
      ..writeByte(9)
      ..write(obj.years);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStatisticsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
