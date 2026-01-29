// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barcode_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BarcodeResultModelAdapter extends TypeAdapter<BarcodeResultModel> {
  @override
  final int typeId = 13;

  @override
  BarcodeResultModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BarcodeResultModel(
      brand: fields[0] as String?,
      co2Packaging: fields[1] as double?,
      code: fields[2] as String?,
      ecoGrade: fields[3] as String?,
      files: (fields[4] as List?)?.cast<BarcodeResultFileModel>(),
      id: fields[5] as int?,
      instructions: fields[6] as String?,
      mainMaterial: fields[7] as String?,
      name: fields[8] as String?,
      trashType: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, BarcodeResultModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.brand)
      ..writeByte(1)
      ..write(obj.co2Packaging)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.ecoGrade)
      ..writeByte(4)
      ..write(obj.files)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.instructions)
      ..writeByte(7)
      ..write(obj.mainMaterial)
      ..writeByte(8)
      ..write(obj.name)
      ..writeByte(9)
      ..write(obj.trashType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BarcodeResultModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
