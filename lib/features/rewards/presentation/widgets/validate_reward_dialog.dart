import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../data/models/validate_reward.dart';
import 'validate_reward_form.dart';

class ValidateRewardDialog extends StatelessWidget {
  final String redeemCode;
  final bool isValidating;
  final String? errorMessage;
  final String? successMessage;
  final ValidateRewardModel? validatedReward;
  final ValueChanged<String> onCodeChanged;
  final VoidCallback onValidate;
  final VoidCallback onCancel;
  final VoidCallback? onInvalidate;

  const ValidateRewardDialog({
    super.key,
    required this.redeemCode,
    required this.isValidating,
    this.errorMessage,
    this.successMessage,
    this.validatedReward,
    required this.onCodeChanged,
    required this.onValidate,
    required this.onCancel,
    this.onInvalidate,
  });

  @override
  Widget build(BuildContext context) {
    final isRewardValidated = validatedReward?.product != null;
    
    return ShadDialog(
      title: Text(isRewardValidated ? 'Reward Details' : 'Validate Reward'),
      description: Text(isRewardValidated 
          ? 'Review the reward details below.' 
          : 'Enter the redeem code to validate the reward.'),
      actions: [
        ShadButton.outline(
          onPressed: isValidating ? null : onCancel,
          child: const Text('Cancel'),
        ),
        if (isRewardValidated)
          ShadButton(
            onPressed: onInvalidate,
            child: const Text('Invalidate Reward'),
          )
        else
          ShadButton(
            onPressed: (isValidating || redeemCode.trim().isEmpty) ? null : onValidate,
            child: isValidating
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Validate'),
          ),
      ],
      child: SizedBox(
        width: 500,
        child: isRewardValidated 
            ? _buildRewardDetails()
            : ValidateRewardForm(
                redeemCode: redeemCode,
                isValidating: isValidating,
                errorMessage: errorMessage,
                successMessage: successMessage,
                onCodeChanged: onCodeChanged,
                onValidate: onValidate,
              ),
      ),
    );
  }

  Widget _buildRewardDetails() {
    final product = validatedReward?.product;
    if (product == null) return const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        
        // Product Image
        if (product.files?.isNotEmpty == true)
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[100],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product.files!.first.url ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.image, size: 48, color: Colors.grey),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        
        const SizedBox(height: 16),
        
        // Product Name
        if (product.name?.isNotEmpty == true)
          Text(
            product.name!,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        
        const SizedBox(height: 8),
        
        // Brand
        if (product.brand?.isNotEmpty == true)
          Row(
            children: [
              const Text('Brand: ', style: TextStyle(fontWeight: FontWeight.w500)),
              Text(product.brand!),
            ],
          ),
        
        const SizedBox(height: 8),
        
        // Expiry Date
        if (product.expiryDate != null)
          Row(
            children: [
              const Text('Expires: ', style: TextStyle(fontWeight: FontWeight.w500)),
              Text('${product.expiryDate!.day}/${product.expiryDate!.month}/${product.expiryDate!.year}'),
            ],
          ),
        
        const SizedBox(height: 8),
        
        // Description
        if (product.description?.isNotEmpty == true)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Description:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(
                product.description!,
                style: TextStyle(color: Colors.grey[700]),
              ),
            ],
          ),
        
        const SizedBox(height: 16),
      ],
    );
  }
}