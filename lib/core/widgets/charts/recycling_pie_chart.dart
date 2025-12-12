import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart' as fl;
import '../../app/themes/app_colors.dart';
import '../../app/themes/app_text_styles.dart';
import '../../../features/dashboard/data/models/chart_data.dart';
import '../../../features/dashboard/data/models/chart_config.dart';

class RecyclingPieChart extends StatefulWidget {
  final List<ChartData> data;
  final ChartConfig config;
  final Function(ChartData)? onSectionTapped;

  const RecyclingPieChart({
    super.key,
    required this.data,
    required this.config,
    this.onSectionTapped,
  });

  @override
  State<RecyclingPieChart> createState() => _RecyclingPieChartState();
}

class _RecyclingPieChartState extends State<RecyclingPieChart> {
  int? selectedIndex;
  int? hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: AppColors.card,
      child: Container(
        constraints: BoxConstraints(maxHeight: widget.config.maxHeight ?? 400),
        padding: widget.config.padding ?? const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            Expanded(
              child: Row(
                children: [
                  Expanded(flex: 2, child: _buildPieChart()),
                  if (widget.config.showLegend) ...[
                    const SizedBox(width: 16),
                    Expanded(flex: 1, child: _buildLegend()),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.config.title,
          style: AppTextStyles.headlineLarge.copyWith(
            color: AppColors.foreground,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (widget.config.subtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            widget.config.subtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.mutedForeground,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPieChart() {
    return fl.PieChart(
      fl.PieChartData(
        sections: _createPieSections(),
        sectionsSpace: 2,
        centerSpaceRadius: 60,
        pieTouchData: fl.PieTouchData(
          enabled: widget.config.showTooltip,
          touchCallback: (fl.FlTouchEvent event, pieTouchResponse) {
            final touchedIndex =
                pieTouchResponse?.touchedSection?.touchedSectionIndex;

            if (event is fl.FlTapUpEvent) {
              // Handle tap events
              if (touchedIndex != null && touchedIndex < widget.data.length) {
                widget.onSectionTapped?.call(widget.data[touchedIndex]);
              }
              setState(() {
                selectedIndex = touchedIndex;
              });
            } else if (event is fl.FlPointerHoverEvent) {
              // Handle hover events
              setState(() {
                hoveredIndex = touchedIndex;
              });
            } else if (event is fl.FlPointerExitEvent) {
              // Handle hover exit
              setState(() {
                hoveredIndex = null;
              });
            }
          },
        ),
      ),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubic,
    );
  }

  List<fl.PieChartSectionData> _createPieSections() {
    final total = widget.data.fold<double>(0, (sum, item) => sum + item.value);

    // Calculate cumulative angles for positioning
    double currentAngle = 0;

    return widget.data.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final isSelected = index == selectedIndex;
      final isHovered = index == hoveredIndex;
      final isHighlighted = isSelected || isHovered;
      final percentage = (data.value / total * 100).toStringAsFixed(1);

      // Calculate the middle angle of this section for positioning
      final sectionAngle = (data.value / total) * 360;
      final middleAngle = currentAngle + (sectionAngle / 2);
      currentAngle += sectionAngle;

      // Calculate dynamic offset based on position
      final dynamicOffset = _calculateBadgeOffset(middleAngle);

      return fl.PieChartSectionData(
        color: isHovered ? data.color.withOpacity(0.85) : data.color,
        value: data.value,
        title: '$percentage%',
        radius: isHighlighted ? 70 : 60,
        titleStyle: AppTextStyles.labelMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: isHighlighted ? 16 : 14,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.8),
              offset: const Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
        badgeWidget:
            (isSelected || isHovered) ? _buildTooltipBadge(data) : null,
        badgePositionPercentageOffset: dynamicOffset,
      );
    }).toList();
  }

  double _calculateBadgeOffset(double angleInDegrees) {
    // Normalize angle to 0-360 range
    final normalizedAngle = angleInDegrees % 360;

    // Fine-tuned offset values for consistent visual spacing
    // Based on the tooltip's natural positioning relative to pie sections
    if (normalizedAngle >= 315 || normalizedAngle < 45) {
      // Top area (12 o'clock region) - standard distance
      return 1.4;
    } else if (normalizedAngle >= 45 && normalizedAngle < 135) {
      // Right area (3 o'clock region) - standard distance
      return 1.3;
    } else if (normalizedAngle >= 135 && normalizedAngle < 225) {
      // Bottom area (6 o'clock region) - closer to prevent excessive gap
      return 1.65;
    } else {
      // Left area (9 o'clock region) - standard distance
      return 1.6;
    }
  }

  Widget _buildTooltipBadge(ChartData data) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 100),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: data.color, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.foreground,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  '${data.value.toInt()} recycled',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.mutedForeground,
                    fontSize: 9,
                  ),
                ),
                Text(
                  data.category,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: data.color,
                    fontWeight: FontWeight.w500,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Products',
          style: AppTextStyles.headlineSmall.copyWith(
            color: AppColors.foreground,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.builder(
            itemCount: widget.data.length,
            itemBuilder: (context, index) {
              final item = widget.data[index];
              final isSelected = index == selectedIndex;
              final isHovered = index == hoveredIndex;
              final isHighlighted = isSelected || isHovered;
              final total = widget.data.fold<double>(
                0,
                (sum, item) => sum + item.value,
              );
              final percentage = (item.value / total * 100).toStringAsFixed(1);

              return MouseRegion(
                onEnter: (_) => setState(() => hoveredIndex = index),
                onExit: (_) => setState(() => hoveredIndex = null),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isHighlighted
                            ? AppColors.accent.withOpacity(0.1)
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          isHighlighted ? AppColors.accent : AppColors.border,
                      width: isHighlighted ? 2 : 1,
                    ),
                    boxShadow:
                        isHighlighted
                            ? [
                              BoxShadow(
                                color: AppColors.accent.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                            : null,
                  ),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isHighlighted ? 14 : 12,
                        height: isHighlighted ? 14 : 12,
                        decoration: BoxDecoration(
                          color: item.color,
                          borderRadius: BorderRadius.circular(
                            isHighlighted ? 3 : 2,
                          ),
                          boxShadow:
                              isHighlighted
                                  ? [
                                    BoxShadow(
                                      color: item.color.withOpacity(0.4),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                  : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 200),
                              style: AppTextStyles.labelMedium.copyWith(
                                color: AppColors.foreground,
                                fontWeight:
                                    isHighlighted
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                              ),
                              child: Text(
                                item.label,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              item.category,
                              style: AppTextStyles.labelSmall.copyWith(
                                color:
                                    isHighlighted
                                        ? AppColors.foreground
                                        : AppColors.mutedForeground,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            item.value.toInt().toString(),
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.foreground,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '$percentage%',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.mutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
