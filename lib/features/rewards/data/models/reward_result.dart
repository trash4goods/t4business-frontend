import '../../../../core/app/app_images.dart';
import '../../../rules_v2/data/models/rules_result.dart';
import 'reward_result_file.dart';
import 'reward_upload_file.dart';

class RewardResultModel {
  final List<String>? categories;
  final int? departmentId;
  final String? description;
  final DateTime? expiryDate;
  final List<RewardResultFileModel>? files;
  final int? id;
  final String? name;
  final int? quantity;
  final String? specifications;
  final String? status;
  List<RewardUploadFileModel>? uploadFiles;
  List<int>? deleteFiles; // ids of files to delete
  String?
  removeAll; // "true" would remove all files. if new quantity value is less than the current quantity, this would be set to "true".
  final int? addQuantity;
  final String? productType;
  final bool? isAdmin;
  final List<RulesResultModel>? rules;
  final List<int>? addRuleIds; //used when creating/editing
  final List<int>? removeRuleIds; // used only when editing
  

  RewardResultModel({
    this.categories,
    this.departmentId,
    this.description,
    this.expiryDate,
    this.files,
    this.id,
    this.name,
    this.quantity,
    this.specifications,
    this.status,
    this.uploadFiles,
    this.deleteFiles,
    this.removeAll,
    this.addQuantity,
    this.isAdmin,
    this.productType,
    this.rules,
    this.addRuleIds,
    this.removeRuleIds,
  });

  factory RewardResultModel.fromJson(Map<String, dynamic> json) {
    return RewardResultModel(
      categories:
          json['categories'] != null
              ? List<String>.from(json['categories'] as List)
              : null,
      departmentId: json['department_id'] as int?,
      description: json['description'] as String?,
      expiryDate:
          json['expiry_date'] != null
              ? DateTime.parse(json['expiry_date'] as String)
              : null,
      files:
          json['files'] != null
              ? List<RewardResultFileModel>.from(
                json['files'].map((x) => RewardResultFileModel.fromJson(x)),
              )
              : null,
      id: json['id'] as int?,
      name: json['name'] as String?,
      quantity: json['quantity'] as int?,
      specifications: json['specifications'] as String?,
      status: json['status'] as String?,
      productType: json['product_type'] as String?,
      isAdmin: json['is_admin'] as bool?,
      rules: json['rules'] != null
          ? List<RulesResultModel>.from(
              (json['rules'] as List).map((rule) => RulesResultModel.fromJson(rule))
            )
          : null,
    );
  }

  bool get canCheckout => (quantity ?? 0) > 0 && status == 'active';
  String get headerImage => files?.firstOrNull?.url ?? '';
  // carousel images excluding the first
  List<String> get carouselImage =>
      files?.skip(1).map((x) => x.url ?? '').toList() ?? [];
  String get logo => AppImages.logo;

  Map<String, dynamic> toJson() => {
    if (categories != null) 'categories': categories,
    if (departmentId != null) 'department_id': departmentId,
    if (description != null) 'description': description,
    if (expiryDate != null) 'expiry_date': expiryDate?.toIso8601String(),
    if (files != null) 'files': files?.map((x) => x.toJson()).toList(),
    if (id != null) 'id': id,
    if (name != null) 'name': name,
    if (addQuantity != null) 'add_quantity': addQuantity,
    if (quantity != null)
      'quantity': quantity, // it increments the quantity by the given number.
    if (specifications != null) 'specifications': specifications,
    if (status != null) 'status': status,
    if (removeAll != null)
      'remove_all': removeAll, // "true" would remove all files.
    if (uploadFiles != null)
      'upload_files':
          uploadFiles
              ?.map((x) => x.toJson())
              .toList(), // upload multiple image.
    if (deleteFiles != null)
      'delete_files': deleteFiles, // ids of files to delete
    if(productType != null) 'product_type': productType,
    if(isAdmin != null) 'is_admin': isAdmin,
    // UPDATE/
    if (addRuleIds != null) 'add_rule_ids': addRuleIds,
    if (removeRuleIds != null) 'remove_rule_ids': removeRuleIds,
  };
}
