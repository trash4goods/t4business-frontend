import 'package:flutter/material.dart';

class RecycledProductData {
  final String name;
  final int recycledCount;
  final Color color;
  final String category;

  const RecycledProductData({
    required this.name,
    required this.recycledCount,
    required this.color,
    required this.category,
  });
}