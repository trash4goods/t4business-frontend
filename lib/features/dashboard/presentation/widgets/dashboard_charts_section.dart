import 'package:flutter/material.dart';
import 'charts_section.dart';
import '../../data/models/chart_data.dart';

class DashboardChartsSection extends StatelessWidget {
  final BoxConstraints constraints;
  final List<ChartData> data;
  final ValueChanged<ChartData> onSectionTapped;
  final String title;
  final String subtitle;

  const DashboardChartsSection({
    super.key,
    required this.constraints,
    required this.data,
    required this.onSectionTapped,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ChartsSection(
      constraints: constraints,
      data: data,
      onSectionTapped: onSectionTapped,
      title: title,
      subtitle: subtitle,
    );
  }
}
