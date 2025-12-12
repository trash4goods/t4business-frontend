import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../app/themes/app_colors.dart';

class ProductListItem extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String description;
  final String? status;
  final VoidCallback? onEdit;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const ProductListItem({
    super.key,
    this.imageUrl,
    required this.title,
    required this.description,
    this.status,
    this.onEdit,
    this.onDuplicate,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ShadCard(
      padding: const EdgeInsets.all(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: AppColors.surfaceElevated,
                border: Border.all(color: AppColors.border),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child:
                    imageUrl != null && imageUrl!.isNotEmpty
                        ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  _buildPlaceholder(),
                        )
                        : _buildPlaceholder(),
              ),
            ),

            const SizedBox(width: 12),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (status != null) ...[
                    const SizedBox(height: 4),
                    _buildStatusChip(status!),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Action Buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShadButton.outline(
                  onPressed: onEdit,
                  size: ShadButtonSize.sm,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.edit_outlined, size: 14),
                      SizedBox(width: 4),
                      Text('Edit', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),

                const SizedBox(width: 6),

                ShadButton.outline(
                  onPressed: onDelete,
                  size: ShadButtonSize.sm,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.delete_outline, size: 14, color: Colors.red),
                      SizedBox(width: 4),
                      Text(
                        'Delete',
                        style: TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final isActive = status.toLowerCase() == 'active';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color:
            isActive
                ? Colors.green.withValues(alpha: 0.1)
                : Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color:
              isActive
                  ? Colors.green.withValues(alpha: 0.3)
                  : Colors.orange.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.green.shade700 : Colors.orange.shade700,
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.surfaceElevated,
      child: const Icon(
        Icons.image_outlined,
        color: AppColors.textSecondary,
        size: 24,
      ),
    );
  }
}
