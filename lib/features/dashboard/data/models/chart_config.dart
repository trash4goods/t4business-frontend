import 'package:flutter/material.dart';

class ChartConfig {
  final String title;
  final String subtitle;
  final bool showTooltip;
  final bool showLegend;
  final double? maxHeight;
  final EdgeInsets? padding;

  const ChartConfig({
    required this.title,
    this.subtitle = '',
    this.showTooltip = true,
    this.showLegend = true,
    this.maxHeight,
    this.padding,
  });
}