// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode_result_file_createdby.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BarcodeResultFileCreatedByModelAdapter
    extends TypeAdapter<BarcodeResultFileCreatedByModel> {
  @override
  final int typeId = 21;

  @override
  BarcodeResultFileCreatedByModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BarcodeResultFileCreatedByModel(
      id: fields[0] as int?,
      name: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BarcodeResultFileCreatedByModel obj) {
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
      other is BarcodeResultFileCreatedByModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
