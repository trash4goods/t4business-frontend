import 'reward_result_file.dart';
import 'validate_reward_event.dart';

class ValidateRewardProductModel {
  final String? brand;
  final List<String>? categories;
  final String? description;
  final ValidateRewardEventModel? event;
  final DateTime? expiryDate;
  final List<RewardResultFileModel>? files;
  final String? name;
  final String? productType;

  ValidateRewardProductModel({
    this.brand,
    this.categories,
    this.description,
    this.event,
    this.expiryDate,
    this.files,
    this.name,
    this.productType,
  });

  factory ValidateRewardProductModel.fromJson(Map<String, dynamic> json) {
    return ValidateRewardProductModel(
      brand: json['brand'] as String?,
      categories: json['categories'] != null
          ? List<String>.from(json['categories'] as List)
          : null,
      description: json['description'] as String?,
      event: json['event'] != null
          ? ValidateRewardEventModel.fromJson(json['event'] as Map<String, dynamic>)
          : null,
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'] as String)
          : null,
      files: json['files'] != null
          ? List<RewardResultFileModel>.from(
              json['files'].map((x) => RewardResultFileModel.fromJson(x)),
            )
          : null,
      name: json['name'] as String?,
      productType: json['product_type'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (brand != null) 'brand': brand,
    if (categories != null) 'categories': categories,
    if (description != null) 'description': description,
    if (event != null) 'event': event?.toJson(),
    if (expiryDate != null) 'expiry_date': expiryDate?.toIso8601String(),
    if (files != null) 'files': files?.map((x) => x.toJson()).toList(),
    if (name != null) 'name': name,
    if (productType != null) 'product_type': productType,
  };
}