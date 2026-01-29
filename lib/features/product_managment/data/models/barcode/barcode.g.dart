// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BarcodeModelAdapter extends TypeAdapter<BarcodeModel> {
  @override
  final int typeId = 11;

  @override
  BarcodeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BarcodeModel(
      pagination: fields[0] as BarcodePaginationModel?,
      result: (fields[1] as List?)?.cast<BarcodeResultModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, BarcodeModel obj) {
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
      other is BarcodeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
