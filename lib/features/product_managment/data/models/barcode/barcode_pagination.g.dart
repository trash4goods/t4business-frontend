// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode_pagination.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BarcodePaginationModelAdapter
    extends TypeAdapter<BarcodePaginationModel> {
  @override
  final int typeId = 12;

  @override
  BarcodePaginationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BarcodePaginationModel(
      count: fields[0] as int?,
      hasNext: fields[1] as bool?,
      page: fields[2] as int?,
      perPage: fields[3] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, BarcodePaginationModel obj) {
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
      other is BarcodePaginationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
