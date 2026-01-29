import 'package:hive_flutter/hive_flutter.dart';

import '../../../product_managment/data/models/barcode/barcode_result.dart';
import '../../../rewards/data/models/reward_result.dart';

part 'rules_result.g.dart';

@HiveType(typeId: 16)
class RulesResultModel {
  // General
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? status; // "active" or "inactive". by default active. field required
  @HiveField(2)
  int?
  quantity; // how many items (barcodes) needed to recycle to trigger rule. field required
  @HiveField(3)
  int?
  cooldownPeriod; // number of days for the rule to be available again for the same user after he triggered it, if none there is no cooldown. field not required
  @HiveField(4)
  int?
  usageLimit; // how many times the same user can trigger this rule, if none is infinite. field not required
  @HiveField(5)
  DateTime?
  expiryDate; // date to expire the rule, after this date the rule is no longer active. field not required
  @HiveField(6)
  int? departmentId; // non-displayed

  // Get
  @HiveField(7)
  int? id;
  @HiveField(8)
  List<BarcodeResultModel>? barcodes;
  @HiveField(9)
  List<RewardResultModel>? rewards;

  // Create
  @HiveField(10)
  List<int>?
  productIds; // product ids to associate to this rule as rewards. the field is not required.
  @HiveField(11)
  String?
  allProducts; // "False" by default. "False" or "True". if "True" associates all products owned by the user department to this rule. the field is not required.
  @HiveField(12)
  List<int>?
  barcodeIds; // barcode ids to associate to this rule as items needed to recycle. the field is not required.
  @HiveField(13)
  String?
  allBarcodes; // "False" by default. "False" or "True". if "True" associates all barcodes owned by the user department to this rule. the field is not required.

  // Edit
  @HiveField(14)
  String?
  addAllProducts; // "False" by default. "False" or "True". if "True" associates all products owned by the user department to this rule
  @HiveField(15)
  List<int>?
  addProductIds; // product ids to associate to this rule as rewards. field not required
  @HiveField(16)
  String?
  addAllBarcodes; // "False" by default. "False" or "True". if "True" associates all barcodes owned by the user department to this rule
  @HiveField(17)
  List<int>?
  addBarcodeIds; // list of barcode ids to add to this rule. the field is not required.
  @HiveField(18)
  List<int>?
  removeProductIds; // list of product ids to remove from this rule. the field is not required.
  @HiveField(19)
  List<int>?
  removeBarcodeIds; // list of barcode ids to remove from this rule. the field is not required.
  @HiveField(20)
  String?
  removeAll; // "False" by default. "False" or "True". if "True" removes all barcodes and products from this rule. the field is not required.

  RulesResultModel({
    this.id,
    this.name,
    this.status,
    this.quantity,
    this.cooldownPeriod,
    this.usageLimit,
    this.expiryDate,
    this.departmentId,
    // Create operation fields
    this.allProducts,
    this.productIds,
    this.allBarcodes,
    this.barcodeIds,
    // Edit operation fields
    this.addAllProducts,
    this.addProductIds,
    this.addAllBarcodes,
    this.addBarcodeIds,
    this.removeProductIds,
    this.removeBarcodeIds,
    this.removeAll,
    // Associated data
    this.rewards,
    this.barcodes,
  });

  factory RulesResultModel.fromJson(Map<String, dynamic> json) =>
      RulesResultModel(
        id: json['id'] as int?,
        name: json['name'] as String?,
        status: json['status'] as String?,
        quantity: json['quantity'] as int?,
        cooldownPeriod: json['cooldown_period'] as int?,
        usageLimit: json['usage_limit'] as int?,
        expiryDate:
            json['expiry_date'] == null
                ? null
                : DateTime.parse(json['expiry_date'] as String),
        addAllProducts: json['add_all_products'] as String?,
        addProductIds:
            json['add_product_ids'] == null
                ? null
                : List<int>.from(json['add_product_ids'] as List<int>),
        addAllBarcodes: json['add_all_barcodes'] as String?,
        addBarcodeIds:
            json['add_barcode_ids'] == null
                ? null
                : List<int>.from(json['add_barcode_ids'] as List<int>),
        removeProductIds:
            json['remove_product_ids'] == null
                ? null
                : List<int>.from(json['remove_product_ids'] as List<int>),
        removeBarcodeIds:
            json['remove_barcode_ids'] == null
                ? null
                : List<int>.from(json['remove_barcode_ids'] as List<int>),
        removeAll: json['remove_all'] as String?,
        rewards:
            json['products'] != null
                ? List<RewardResultModel>.from(
                  json['products'].map((x) => RewardResultModel.fromJson(x)),
                )
                : null,
        barcodes:
            json['barcodes'] != null
                ? List<BarcodeResultModel>.from(
                  json['barcodes'].map((x) => BarcodeResultModel.fromJson(x)),
                )
                : null,
      );

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (name != null) 'name': name,
    if (status != null) 'status': status,
    if (quantity != null) 'quantity': quantity,
    if (cooldownPeriod != null) 'cooldown_period': cooldownPeriod,
    if (usageLimit != null) 'usage_limit': usageLimit,
    if (expiryDate != null) 'expiry_date': expiryDate?.toIso8601String(),
    if (addAllProducts != null) 'add_all_products': addAllProducts,
    if (addProductIds != null) 'add_product_ids': addProductIds,
    if (addAllBarcodes != null) 'add_all_barcodes': addAllBarcodes,
    if (addBarcodeIds != null) 'add_barcode_ids': addBarcodeIds,
    if (removeProductIds != null) 'remove_product_ids': removeProductIds,
    if (removeBarcodeIds != null) 'remove_barcode_ids': removeBarcodeIds,
    if (removeAll != null) 'remove_all': removeAll,
    if (rewards != null) 'rewards': rewards?.map((x) => x.toJson()).toList(),
    if (barcodes != null) 'barcodes': barcodes?.map((x) => x.toJson()).toList(),
    // Create
    if (productIds != null) 'product_ids': productIds,
    if (allProducts != null) 'all_products': allProducts,
    if (barcodeIds != null) 'barcode_ids': barcodeIds,
    if (allBarcodes != null) 'all_barcodes': allBarcodes,
  };
}
