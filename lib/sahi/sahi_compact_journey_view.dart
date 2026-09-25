import 'package:flutter/material.dart';
import 'package:tradeable_learn_widget/sahi/widgets/concept_video.dart';
import 'package:tradeable_learn_widget/sahi/widgets/continue_journey_button.dart';
import 'package:tradeable_learn_widget/sahi/widgets/course_progress_bar.dart';
import 'package:tradeable_learn_widget/sahi/widgets/journey_item.dart';
import 'package:tradeable_learn_widget/sahi/widgets/journey_tabs.dart';
import 'package:tradeable_learn_widget/sahi/widgets/journey_top_bar.dart';
import 'package:tradeable_learn_widget/sahi/widgets/video_banner.dart';
import 'package:tradeable_learn_widget/tlw.dart';
import 'package:tradeable_learn_widget/utils/theme.dart';

class SahiCompactChartView extends StatefulWidget {
  final double progress;
  final String? videoUrl;
  final VoidCallback onProceed;
  final List<JourneyItem> journeyItems;

  const SahiCompactChartView({
    super.key,
    required this.progress,
    required this.onProceed,
    required this.journeyItems,
    this.videoUrl,
  });

  @override
  State<SahiCompactChartView> createState() => _SahiCompactChartViewState();
}

class _SahiCompactChartViewState extends State<SahiCompactChartView> {
  bool _videoTapped = false;

  void _onVideoTap() {
    setState(() => _videoTapped = true);
    launchVideoUrl(widget.videoUrl ?? conceptVideoUrl);
  }

  @override
  Widget build(BuildContext context) {
    final colors =
        TLW().themeData?.customColors ?? Theme.of(context).customColors;

    return Scaffold(
      backgroundColor: colors.sahiMobileTabBarBg,
      appBar: JourneyTopBar(
        onBack: () => Navigator.of(context).pop(),
        onWatch: () => launchVideoUrl(widget.videoUrl ?? conceptVideoUrl),
        journeyItems: widget.journeyItems,
      ),
      body: Column(
        children: [
          CourseProgressBar(
            progress: widget.progress,
            height: 3,
            borderRadius: 0,
            progressBgColor: Colors.transparent,
          ),
          Container(height: 8, color: colors.sahiTabBg),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VideoBanner(
                    onTap: _onVideoTap,
                    image: const AssetImage('assets/bull.png'),
                    borderRadius: 0,
                    height: 200,
                    iconWidget: Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: const Icon(
                        Icons.play_arrow_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const JourneyTabs(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ContinueJourneyButton(
        text: "Proceed",
        enabled: _videoTapped,
        onPressed: widget.onProceed,
        disabledIcon: Icons.lock_outline,
        disabledBackgroundColor: colors.sahiButtonDisabledBgColor,
        disabledTextColor: colors.secondary,
        startColor: colors.sahiGradientPrimaryStart,
        endColor: colors.sahiGradientPrimaryEnd,
      ),
    );
  }
}
