import 'validate_reward_product.dart';

class ValidateRewardModel {
  final String? message;
  final ValidateRewardProductModel? product;
  final String? redeemStatus;

  ValidateRewardModel({
    this.message,
    this.product,
    this.redeemStatus,
  });

  factory ValidateRewardModel.fromJson(Map<String, dynamic> json) {
    return ValidateRewardModel(
      message: json['message'] as String?,
      product: json['product'] != null
          ? ValidateRewardProductModel.fromJson(json['product'] as Map<String, dynamic>)
          : null,
      redeemStatus: json['redeem_status'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    if (message != null) 'message': message,
    if (product != null) 'product': product?.toJson(),
    if (redeemStatus != null) 'redeem_status': redeemStatus,
  };
}