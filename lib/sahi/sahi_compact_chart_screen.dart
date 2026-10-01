import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/sahi/widgets/course_progress_bar.dart';
import 'package:tradeable_learn_widget/sahi/widgets/journey_item.dart';
import 'package:tradeable_learn_widget/sahi/widgets/journey_top_bar.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class SahiCompactChartScreen extends StatelessWidget {
  final Widget chart;
  final Widget bottomAction;
  final Widget? aboveBottomAction;
  final double progress;
  final VoidCallback onBack;
  final List<JourneyItem> journeyItems;
  final bool showJourney;
  final bool showPlayIcon;
  final bool playMuted;

  const SahiCompactChartScreen({
    super.key,
    required this.chart,
    required this.bottomAction,
    this.aboveBottomAction,
    required this.progress,
    required this.onBack,
    required this.journeyItems,
    this.showJourney = true,
    this.showPlayIcon = false,
    this.playMuted = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Scaffold(
      backgroundColor: colors.sahiMobileTabBarBg,
      appBar: JourneyTopBar(
        onBack: onBack,
        journeyItems: journeyItems,
        muted: true,
        showJourney: showJourney,
        showPlayIcon: showPlayIcon,
        playMuted: playMuted,
      ),
      body: Column(
        children: [
          CourseProgressBar(
            progress: progress,
            height: 3,
            borderRadius: 0,
            progressBgColor: Colors.transparent,
          ),
          Container(height: 8, color: colors.sahiMobileTabBarBg),
          Expanded(child: chart),
          if (aboveBottomAction != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: aboveBottomAction!,
            ),
        ],
      ),
      bottomNavigationBar: bottomAction,
    );
  }
}
