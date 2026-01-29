// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rules_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RulesResultModelAdapter extends TypeAdapter<RulesResultModel> {
  @override
  final int typeId = 16;

  @override
  RulesResultModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RulesResultModel(
      id: fields[7] as int?,
      name: fields[0] as String?,
      status: fields[1] as String?,
      quantity: fields[2] as int?,
      cooldownPeriod: fields[3] as int?,
      usageLimit: fields[4] as int?,
      expiryDate: fields[5] as DateTime?,
      departmentId: fields[6] as int?,
      allProducts: fields[11] as String?,
      productIds: (fields[10] as List?)?.cast<int>(),
      allBarcodes: fields[13] as String?,
      barcodeIds: (fields[12] as List?)?.cast<int>(),
      addAllProducts: fields[14] as String?,
      addProductIds: (fields[15] as List?)?.cast<int>(),
      addAllBarcodes: fields[16] as String?,
      addBarcodeIds: (fields[17] as List?)?.cast<int>(),
      removeProductIds: (fields[18] as List?)?.cast<int>(),
      removeBarcodeIds: (fields[19] as List?)?.cast<int>(),
      removeAll: fields[20] as String?,
      rewards: (fields[9] as List?)?.cast<RewardResultModel>(),
      barcodes: (fields[8] as List?)?.cast<BarcodeResultModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, RulesResultModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.cooldownPeriod)
      ..writeByte(4)
      ..write(obj.usageLimit)
      ..writeByte(5)
      ..write(obj.expiryDate)
      ..writeByte(6)
      ..write(obj.departmentId)
      ..writeByte(7)
      ..write(obj.id)
      ..writeByte(8)
      ..write(obj.barcodes)
      ..writeByte(9)
      ..write(obj.rewards)
      ..writeByte(10)
      ..write(obj.productIds)
      ..writeByte(11)
      ..write(obj.allProducts)
      ..writeByte(12)
      ..write(obj.barcodeIds)
      ..writeByte(13)
      ..write(obj.allBarcodes)
      ..writeByte(14)
      ..write(obj.addAllProducts)
      ..writeByte(15)
      ..write(obj.addProductIds)
      ..writeByte(16)
      ..write(obj.addAllBarcodes)
      ..writeByte(17)
      ..write(obj.addBarcodeIds)
      ..writeByte(18)
      ..write(obj.removeProductIds)
      ..writeByte(19)
      ..write(obj.removeBarcodeIds)
      ..writeByte(20)
      ..write(obj.removeAll);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RulesResultModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
