import 'dart:developer';

import 'package:flutter/material.dart';
import 'reward_image_placeholder.dart';

class RewardViewCardImage extends StatelessWidget {
  final String? headerImage;

  const RewardViewCardImage({
    super.key,
    required this.headerImage,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = headerImage;

    if ((imageUrl ?? '').isNotEmpty) {
    log('[RewardCardImage] imageUrl: $imageUrl');
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        child: (imageUrl!.contains('http')) || (imageUrl.contains('https://'))
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                    log('[RewardCardImage] error: $error');
                    return const RewardViewImagePlaceholder();
                }
              )
            : Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                    log('[RewardCardImage] error: $error');
                    return const RewardViewImagePlaceholder();
                }
              ),
      );
    } else {
      return const RewardViewImagePlaceholder();
    }
  }
}
