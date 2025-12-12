import 'package:flutter/material.dart';
import 'package:t4g_for_business/features/product_managment/presentation/view/product.dart';
import 'page_header.dart';

class ProductManagementContent extends StatelessWidget {
  final BoxConstraints constraints;
  const ProductManagementContent({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(
          constraints: constraints,
          title: 'Recycling Products',
          subtitle: 'Manage your product catalog and track recycling performance',
          icon: Icons.recycling_outlined,
        ),
        const Expanded(child: ProductsPage()),
      ],
    );
  }
}
