import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../presenters/interface/rule.dart';
import 'rules_stats_cards.dart';
import 'mobile_stats_row.dart';

class RulesHeader extends StatelessWidget {
  const RulesHeader({
    super.key,
    required this.presenter,
    required this.isMobile,
    required this.isTablet,
    required this.hasScaffoldAncestor,
  });

  final RulesPresenterInterface presenter;
  final bool isMobile;
  final bool isTablet;
  final bool hasScaffoldAncestor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (isMobile && hasScaffoldAncestor) ...[
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, size: 20),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                    style: IconButton.styleFrom(
                      foregroundColor: const Color(0xFF0F172A),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.rule,
                  size: 24,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rules',
                      style: TextStyle(
                        fontSize: isMobile ? 20 : 24,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    if (!isMobile)
                      const Text(
                        'Create and manage recycling rules for your rewards program',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF64748B),
                        ),
                      ),
                  ],
                ),
              ),
              if (!isMobile) ...[
                const SizedBox(width: 16),
                RulesStatsCards(presenter: presenter, isTablet: isTablet),
              ],
            ],
          ),
          if (isMobile) ...[
            const SizedBox(height: 16),
            MobileStatsRow(presenter: presenter),
          ],
        ],
      ),
    );
  }
}
