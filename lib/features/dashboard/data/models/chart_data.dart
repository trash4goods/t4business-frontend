import 'package:flutter/material.dart';
import 'recycled_product_data.dart';

class ChartData {
  final String label;
  final double value;
  final Color color;
  final String category;

  const ChartData({
    required this.label,
    required this.value,
    required this.color,
    required this.category,
  });

  static List<ChartData> fromRecycledProducts(List<RecycledProductData> products) {
    return products.map((product) => ChartData(
      label: product.name,
      value: product.recycledCount.toDouble(),
      color: product.color,
      category: product.category,
    )).toList();
  }
}