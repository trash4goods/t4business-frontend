// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reward_result.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RewardResultModelAdapter extends TypeAdapter<RewardResultModel> {
  @override
  final int typeId = 19;

  @override
  RewardResultModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RewardResultModel(
      categories: (fields[0] as List?)?.cast<String>(),
      departmentId: fields[1] as int?,
      description: fields[2] as String?,
      expiryDate: fields[3] as DateTime?,
      files: (fields[4] as List?)?.cast<RewardResultFileModel>(),
      id: fields[5] as int?,
      name: fields[6] as String?,
      quantity: fields[7] as int?,
      specifications: fields[8] as String?,
      status: fields[9] as String?,
      uploadFiles: (fields[10] as List?)?.cast<RewardUploadFileModel>(),
      deleteFiles: (fields[11] as List?)?.cast<int>(),
      removeAll: fields[12] as String?,
      addQuantity: fields[13] as int?,
      isAdmin: fields[15] as bool?,
      productType: fields[14] as String?,
      rules: (fields[16] as List?)?.cast<RulesResultModel>(),
      addRuleIds: (fields[17] as List?)?.cast<int>(),
      removeRuleIds: (fields[18] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, RewardResultModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.categories)
      ..writeByte(1)
      ..write(obj.departmentId)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.expiryDate)
      ..writeByte(4)
      ..write(obj.files)
      ..writeByte(5)
      ..write(obj.id)
      ..writeByte(6)
      ..write(obj.name)
      ..writeByte(7)
      ..write(obj.quantity)
      ..writeByte(8)
      ..write(obj.specifications)
      ..writeByte(9)
      ..write(obj.status)
      ..writeByte(10)
      ..write(obj.uploadFiles)
      ..writeByte(11)
      ..write(obj.deleteFiles)
      ..writeByte(12)
      ..write(obj.removeAll)
      ..writeByte(13)
      ..write(obj.addQuantity)
      ..writeByte(14)
      ..write(obj.productType)
      ..writeByte(15)
      ..write(obj.isAdmin)
      ..writeByte(16)
      ..write(obj.rules)
      ..writeByte(17)
      ..write(obj.addRuleIds)
      ..writeByte(18)
      ..write(obj.removeRuleIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RewardResultModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
