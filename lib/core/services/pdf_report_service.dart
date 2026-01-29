import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart';

class PdfReportService {
  static Future<void> generateAndDownloadReport({
    required String businessName,
    required String reportPeriod,
    required Map<String, dynamic> dashboardData,
  }) async {
    try {
      final pdf = pw.Document();
      final now = DateTime.now();
      final formatter = DateFormat('MMMM dd, yyyy');
      
      // Generate PDF content
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              // Header
              _buildHeader(businessName, reportPeriod, formatter.format(now)),
              pw.SizedBox(height: 30),
              
              // Executive Summary
              _buildExecutiveSummary(dashboardData),
              pw.SizedBox(height: 25),
              
              // Key Metrics Section
              _buildKeyMetrics(dashboardData),
              pw.SizedBox(height: 25),
              
              // Performance Analysis
              _buildPerformanceAnalysis(dashboardData),
              pw.SizedBox(height: 25),
              
              // Environmental Impact
              _buildEnvironmentalImpact(dashboardData),
              pw.SizedBox(height: 25),
              
              // Business Insights
              _buildBusinessInsights(dashboardData),
              pw.SizedBox(height: 25),
              
              // Recommendations
              _buildRecommendations(dashboardData),
              pw.SizedBox(height: 30),
              
              // Footer
              _buildFooter(formatter.format(now)),
            ];
          },
        ),
      );

      // Generate PDF bytes
      final Uint8List pdfBytes = await pdf.save();
      
      // Download the PDF
      await _downloadPdf(pdfBytes, 'Dashboard_Report_${DateFormat('yyyy_MM_dd').format(now)}.pdf');
      
    } catch (e) {
      debugPrint('Error generating PDF report: $e');
      rethrow;
    }
  }

  static pw.Widget _buildHeader(String businessName, String reportPeriod, String generatedDate) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'DASHBOARD REPORT',
                  style: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.green800,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  businessName,
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.normal,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  'Report Period',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey600,
                  ),
                ),
                pw.Text(
                  reportPeriod,
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.normal,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Generated: $generatedDate',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey500,
                  ),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Divider(color: PdfColors.green800, thickness: 2),
      ],
    );
  }

  static pw.Widget _buildExecutiveSummary(Map<String, dynamic> data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Executive Summary', PdfColors.blue800),
        pw.SizedBox(height: 12),
        pw.Container(
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            color: PdfColors.blue50,
            borderRadius: pw.BorderRadius.circular(8),
            border: pw.Border.all(color: PdfColors.blue200),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Your recycling business has shown strong performance during this reporting period. '
                'Key highlights include significant growth in revenue, increased customer engagement, '
                'and positive environmental impact through recycling initiatives.',
                style: pw.TextStyle(fontSize: 12, height: 1.4),
              ),
              pw.SizedBox(height: 12),
              pw.Row(
                children: [
                  pw.Expanded(
                    child: _buildSummaryCard('Total Revenue', '\$${data['totalRevenue'] ?? '12,450'}', PdfColors.green600),
                  ),
                  pw.SizedBox(width: 16),
                  pw.Expanded(
                    child: _buildSummaryCard('Items Recycled', '${data['itemsRecycled'] ?? '2,847'}', PdfColors.blue600),
                  ),
                  pw.SizedBox(width: 16),
                  pw.Expanded(
                    child: _buildSummaryCard('Active Customers', '${data['activeCustomers'] ?? '156'}', PdfColors.orange600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildKeyMetrics(Map<String, dynamic> data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Key Performance Metrics', PdfColors.green800),
        pw.SizedBox(height: 12),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          children: [
            // Header row
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: [
                _buildTableCell('Metric', isHeader: true),
                _buildTableCell('Current Period', isHeader: true),
                _buildTableCell('Previous Period', isHeader: true),
                _buildTableCell('Change', isHeader: true),
              ],
            ),
            // Data rows
            _buildMetricRow('Total Revenue', '\$${data['totalRevenue'] ?? '12,450'}', '\$10,820', '+15%', PdfColors.green600),
            _buildMetricRow('Items Recycled', '${data['itemsRecycled'] ?? '2,847'}', '2,635', '+8%', PdfColors.blue600),
            _buildMetricRow('Active Customers', '${data['activeCustomers'] ?? '156'}', '139', '+12%', PdfColors.orange600),
            _buildMetricRow('Environmental Impact', '${data['environmentalImpact'] ?? '1.2T'} CO₂', '1.14T CO₂', '+5%', PdfColors.green700),
            _buildMetricRow('Average Order Value', '\$${data['avgOrderValue'] ?? '79.80'}', '\$77.20', '+3%', PdfColors.purple600),
            _buildMetricRow('Customer Retention', '${data['customerRetention'] ?? '87'}%', '84%', '+3%', PdfColors.teal600),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildPerformanceAnalysis(Map<String, dynamic> data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Performance Analysis', PdfColors.purple800),
        pw.SizedBox(height: 12),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 2,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildSubsectionTitle('Revenue Trends'),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    '• Strong revenue growth of 15% compared to previous period\n'
                    '• Consistent month-over-month improvement\n'
                    '• Peak performance in premium recycling categories\n'
                    '• Seasonal trends showing increased activity',
                    style: pw.TextStyle(fontSize: 11, height: 1.4),
                  ),
                  pw.SizedBox(height: 16),
                  _buildSubsectionTitle('Customer Engagement'),
                  pw.SizedBox(height: 8),
                  pw.Text(
                    '• 12% increase in active customer base\n'
                    '• Improved customer retention rate (87%)\n'
                    '• Higher frequency of repeat transactions\n'
                    '• Positive feedback on service quality',
                    style: pw.TextStyle(fontSize: 11, height: 1.4),
                  ),
                ],
              ),
            ),
            pw.SizedBox(width: 20),
            pw.Expanded(
              child: pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.purple50,
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: PdfColors.purple200),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Performance Score',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.purple800,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      '92/100',
                      style: pw.TextStyle(
                        fontSize: 32,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green600,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'Excellent Performance',
                      style: pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.green700,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildEnvironmentalImpact(Map<String, dynamic> data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Environmental Impact', PdfColors.green800),
        pw.SizedBox(height: 12),
        pw.Container(
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            color: PdfColors.green50,
            borderRadius: pw.BorderRadius.circular(8),
            border: pw.Border.all(color: PdfColors.green200),
          ),
          child: pw.Column(
            children: [
              pw.Row(
                children: [
                  pw.Expanded(
                    child: _buildImpactCard(
                      'CO₂ Reduced',
                      '${data['environmentalImpact'] ?? '1.2T'} CO₂',
                      'Equivalent to planting 54 trees',
                      PdfColors.green600,
                    ),
                  ),
                  pw.SizedBox(width: 16),
                  pw.Expanded(
                    child: _buildImpactCard(
                      'Waste Diverted',
                      '${data['wasteDiverted'] ?? '3.8T'}',
                      'From landfills this period',
                      PdfColors.blue600,
                    ),
                  ),
                  pw.SizedBox(width: 16),
                  pw.Expanded(
                    child: _buildImpactCard(
                      'Energy Saved',
                      '${data['energySaved'] ?? '2,450'} kWh',
                      'Through recycling processes',
                      PdfColors.orange600,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Text(
                'Your recycling efforts have made a significant positive impact on the environment. '
                'The CO₂ reduction achieved is equivalent to the annual carbon absorption of 54 mature trees, '
                'demonstrating the tangible benefits of your sustainable business practices.',
                style: pw.TextStyle(fontSize: 11, height: 1.4, color: PdfColors.green800),
                textAlign: pw.TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildBusinessInsights(Map<String, dynamic> data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Business Insights', PdfColors.orange800),
        pw.SizedBox(height: 12),
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildInsightBox(
                    'Top Performing Categories',
                    '• Electronics (35% of revenue)\n'
                    '• Metals (28% of revenue)\n'
                    '• Plastics (22% of revenue)\n'
                    '• Paper (15% of revenue)',
                    PdfColors.blue600,
                  ),
                  pw.SizedBox(height: 12),
                  _buildInsightBox(
                    'Peak Activity Times',
                    '• Weekdays: 9 AM - 3 PM\n'
                    '• Weekends: 10 AM - 2 PM\n'
                    '• Monthly peak: Mid-month\n'
                    '• Seasonal: Spring & Fall',
                    PdfColors.purple600,
                  ),
                ],
              ),
            ),
            pw.SizedBox(width: 16),
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildInsightBox(
                    'Customer Demographics',
                    '• Age 25-45: 45% of customers\n'
                    '• Businesses: 35% of revenue\n'
                    '• Repeat customers: 67%\n'
                    '• Local area: 80% of customers',
                    PdfColors.teal600,
                  ),
                  pw.SizedBox(height: 12),
                  _buildInsightBox(
                    'Growth Opportunities',
                    '• Expand electronics recycling\n'
                    '• Partner with local businesses\n'
                    '• Implement loyalty program\n'
                    '• Add pickup services',
                    PdfColors.green600,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildRecommendations(Map<String, dynamic> data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Strategic Recommendations', PdfColors.red800),
        pw.SizedBox(height: 12),
        pw.Container(
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            color: PdfColors.red50,
            borderRadius: pw.BorderRadius.circular(8),
            border: pw.Border.all(color: PdfColors.red200),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildRecommendationItem(
                '1. Expand High-Value Categories',
                'Focus on electronics and metals recycling, which show the highest profit margins and customer demand.',
                'High',
                PdfColors.red600,
              ),
              pw.SizedBox(height: 12),
              _buildRecommendationItem(
                '2. Implement Customer Loyalty Program',
                'Develop a points-based system to increase customer retention and encourage repeat business.',
                'Medium',
                PdfColors.orange600,
              ),
              pw.SizedBox(height: 12),
              _buildRecommendationItem(
                '3. Optimize Operating Hours',
                'Consider extending hours during peak times (9 AM - 3 PM) to capture more business.',
                'Medium',
                PdfColors.orange600,
              ),
              pw.SizedBox(height: 12),
              _buildRecommendationItem(
                '4. Develop B2B Partnerships',
                'Target local businesses for regular recycling contracts to increase revenue stability.',
                'High',
                PdfColors.red600,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildFooter(String generatedDate) {
    return pw.Column(
      children: [
        pw.Divider(color: PdfColors.grey400),
        pw.SizedBox(height: 12),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Generated by T4G Business Dashboard',
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
            pw.Text(
              'Report Date: $generatedDate',
              style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
            ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          'This report contains confidential business information. Please handle accordingly.',
          style: pw.TextStyle(fontSize: 9, color: PdfColors.grey500),
          textAlign: pw.TextAlign.center,
        ),
      ],
    );
  }

  // Helper methods for building components
  static pw.Widget _buildSectionTitle(String title, PdfColor color) {
    return pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 16,
        fontWeight: pw.FontWeight.bold,
        color: color,
      ),
    );
  }

  static pw.Widget _buildSubsectionTitle(String title) {
    return pw.Text(
      title,
      style: pw.TextStyle(
        fontSize: 12,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.grey800,
      ),
    );
  }

  static pw.Widget _buildSummaryCard(String title, String value, PdfColor color) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: color.shade(0.3)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 11 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? PdfColors.grey800 : PdfColors.grey700,
        ),
      ),
    );
  }

  static pw.TableRow _buildMetricRow(String metric, String current, String previous, String change, PdfColor color) {
    return pw.TableRow(
      children: [
        _buildTableCell(metric),
        _buildTableCell(current),
        _buildTableCell(previous),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            change,
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: change.startsWith('+') ? PdfColors.green600 : PdfColors.red600,
            ),
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildImpactCard(String title, String value, String description, PdfColor color) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          title,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey700,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          description,
          style: pw.TextStyle(
            fontSize: 9,
            color: PdfColors.grey600,
          ),
          textAlign: pw.TextAlign.center,
        ),
      ],
    );
  }

  static pw.Widget _buildInsightBox(String title, String content, PdfColor color) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: color.shade(0.05),
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: color.shade(0.2)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 11,
              fontWeight: pw.FontWeight.bold,
              color: color,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            content,
            style: pw.TextStyle(fontSize: 10, height: 1.3),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildRecommendationItem(String title, String description, String priority, PdfColor color) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: pw.BoxDecoration(
            color: color,
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Text(
            priority,
            style: pw.TextStyle(
              fontSize: 8,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
        ),
        pw.SizedBox(width: 12),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                title,
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey800,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                description,
                style: pw.TextStyle(fontSize: 10, height: 1.3),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Future<void> _downloadPdf(Uint8List pdfBytes, String fileName) async {
    if (kIsWeb) {
      // Web download
      final blob = html.Blob([pdfBytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = fileName;
      html.document.body?.children.add(anchor);
      anchor.click();
      html.document.body?.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
    } else {
      // Mobile/Desktop download using printing package
      await Printing.sharePdf(bytes: pdfBytes, filename: fileName);
    }
  }
}
