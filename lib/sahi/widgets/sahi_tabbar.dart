import 'package:fin_chart/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fin_chart/models/journey_state.dart';

class SahiTabBar extends StatelessWidget {
  final List<Map<String, String>> tabs;
  final int currentPageIndex;
  final Function(int) onTabTap;
  final JourneyState? activeJourney;
  final String? courseVideoUrl;
  final bool showCourseVideoBtn;

  const SahiTabBar({
    super.key,
    required this.tabs,
    required this.currentPageIndex,
    required this.onTabTap,
    this.activeJourney,
    this.courseVideoUrl,
    this.showCourseVideoBtn = false,
  });

  IconData _getTabIcon(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('chart')) return Icons.candlestick_chart_outlined;
    if (lower.contains('option')) return Icons.show_chart;
    if (lower.contains('payoff') || lower.contains('pay off')) {
      return Icons.account_balance_wallet_outlined;
    }
    if (lower.contains('table')) return Icons.table_chart_outlined;
    if (lower.contains('insight')) return Icons.insights_outlined;
    return Icons.tab_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).customColors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colors.sahiTabBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colors.sahiTabBorder, width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(tabs.length, (index) {
                final tab = tabs[index];
                final isActive = index == currentPageIndex;
                final title = tab["title"] ?? "";
                return GestureDetector(
                  onTap: () => onTabTap(index),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? colors.sahiContainerBg
                              .withAlpha((0.5 * 255).round())
                          : null,
                      borderRadius: BorderRadius.circular(6),
                      border: isActive
                          ? Border.all(color: colors.sahiTabBorder, width: 1)
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getTabIcon(title),
                          size: 14,
                          color: isActive
                              ? colors.sahiTabActiveBg
                              : colors.sahiTabInactiveText,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          title,
                          style: TextStyle(
                            color: isActive
                                ? colors.sahiTabActiveBg
                                : colors.sahiTabInactiveText,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const Spacer(),
          if (activeJourney != null &&
              !activeJourney!.completed &&
              activeJourney!.videoUrl != null &&
              !activeJourney!.hideVideoBtn)
            GestureDetector(
              onTap: () => launchUrl(Uri.parse(activeJourney!.videoUrl!)),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Learn to read the chart',
                      style: TextStyle(
                        color: colors.secondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Watch Video',
                            style: TextStyle(
                              color: colors.sahiPrimaryTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.play_arrow_outlined,
                            size: 16,
                            color: colors.sahiPrimaryTextColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
